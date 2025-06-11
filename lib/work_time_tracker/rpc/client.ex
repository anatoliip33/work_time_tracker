defmodule WorkTimeTracker.Rpc.Client do
  @moduledoc """
  A test helper module to simulate an RPC client over RabbitMQ.
  """
  import WorkTimeTracker.Helper, only: [format_errors: 1]

  @timeout 5000
  @types %{
    user_id: :integer,
    card_uid: Ecto.UUID
  }

  @doc """
  Makes an RPC call to the application.

  It publishes a message to the specified queue and waits for a response
  on a temporary, exclusive reply queue.
  """
  def call(method, params) do
    with {:ok, valid_params} <- validation(method, params),
         {:ok, conn} <- AMQP.Connection.open(Application.get_env(:work_time_tracker, :rabbitmq)[:url]),
         {:ok, channel} <- AMQP.Channel.open(conn),
         {:ok, %{queue: reply_to}} <- AMQP.Queue.declare(channel, "", exclusive: true) do

      correlation_id = Ecto.UUID.generate()
      request_payload = %{"method" => method, "params" => valid_params}

      AMQP.Basic.consume(channel, reply_to, nil, no_ack: true)

      AMQP.Basic.publish(
        channel,
        "",
        "nfc_rpc_queue",
        JSON.encode!(request_payload),
        [
          correlation_id: correlation_id,
          reply_to: reply_to,
          content_type: "application/json",
          persistent: true
        ]
      )

      receive do
        # n ->
        #   AMQP.Connection.close(conn)
        #   IO.inspect(n, label: "DEBUG: received message")

        {:basic_deliver, payload, %{correlation_id: ^correlation_id}} ->
          AMQP.Connection.close(conn)
          JSON.decode!(payload)
      after
        @timeout ->
          AMQP.Connection.close(conn)
          %{"error" => "timeout"}
      end

    else
      {:error, reason} ->
        reason

      _ ->
        %{"error" => "Failed to connect to RabbitMQ"}
    end
  end

  def validation(method, params) do
    fields = method_specs(method)

    {%{}, fields}
    |> Ecto.Changeset.cast(params, Map.keys(fields))
    |> Ecto.Changeset.validate_required(Map.keys(fields))
    |> case do
      %Ecto.Changeset{valid?: true} ->
        {:ok, params}

      changeset ->
        {:error, format_errors(changeset)}
    end
  end

  defp method_specs("/card/assign"), do: @types |> Map.take([:card_uid, :user_id])
  defp method_specs("/card/touch"), do: @types |> Map.take([:card_uid])
  defp method_specs("/card/delete"), do: @types |> Map.take([:card_uid])
  defp method_specs("/card/list_by_user"), do: @types |> Map.take([:user_id])
  defp method_specs("/card/delete_all_by_user"), do: @types |> Map.take([:user_id])
  defp method_specs(_), do: %{}
end
