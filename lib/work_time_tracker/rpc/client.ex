defmodule WorkTimeTracker.Rpc.Client do
  @moduledoc """
  A test helper module to simulate an RPC client over RabbitMQ.
  """

  @timeout 5000

  @doc """
  Makes an RPC call to the application.

  It publishes a message to the specified queue and waits for a response
  on a temporary, exclusive reply queue.
  """
  def call(method, params) do
    {:ok, conn} = AMQP.Connection.open()
    {:ok, channel} = AMQP.Channel.open(conn)

    {:ok, %{queue: reply_to}} = AMQP.Queue.declare(channel, "", exclusive: true)
    correlation_id = Ecto.UUID.generate()

    request_payload = %{"method" => method, "params" => params}

    AMQP.Basic.consume(channel, reply_to, nil, no_ack: true)

    AMQP.Basic.publish(
      channel,
      "",
      "nfc_rpc_queue",
      Jason.encode!(request_payload),
      [
        correlation_id: correlation_id,
        reply_to: reply_to,
        content_type: "application/json",
        persistent: true
      ]
    )

    receive do
      # n -> IO.inspect(n, label: "DEBUG: received message")

      {:basic_deliver, payload, %{correlation_id: ^correlation_id}} ->
        AMQP.Connection.close(conn)
        Jason.decode!(payload)
    after
      @timeout ->
        AMQP.Connection.close(conn)
        %{"error" => "timeout"}
    end
  end
end
