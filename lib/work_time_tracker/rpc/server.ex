defmodule WorkTimeTracker.Rpc.Server do
  use GenServer
  require Logger

  # alias WorkTimeTracker.Rpc.RabbitmqConnection
  alias WorkTimeTracker.RpcRouter

  @nfc_rpc_queue "nfc_rpc_queue"

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @impl true
  def init(_opts) do
    {:ok, conn} = AMQP.Connection.open(Application.get_env(:work_time_tracker, :rabbitmq)[:url])
    {:ok, channel} = AMQP.Channel.open(conn)

    AMQP.Queue.declare(
      channel,
      @nfc_rpc_queue,
      durable: true
    )

    AMQP.Basic.qos(channel, prefetch_count: 10)
    AMQP.Basic.consume(channel, @nfc_rpc_queue, nil, no_ack: false)

    {:ok, %{channel: channel}}
  end

  @impl true
  def handle_info({:basic_deliver, payload, meta}, state) do
    # :timer.sleep(6000)
    # IO.inspect(meta, label: "SERVER [received] meta")

    %{reply_to: reply_to, correlation_id: correlation_id} = meta

    response =
      with {:ok, %{"method" => method, "params" => params}} <- JSON.decode(payload) do
        RpcRouter.route(method, params)
      else
        {:error, _} -> %{error: "Invalid JSON"}
      end

    publish_response(state.channel, reply_to, correlation_id, response)
    AMQP.Basic.ack(state.channel, meta.delivery_tag)

    {:noreply, state}
  end

  def handle_info({:basic_consume_ok, _}, state), do: {:noreply, state}
  def handle_info({:basic_cancel, _}, state), do: {:noreply, state}
  def handle_info({:basic_cancel_ok, _}, state), do: {:noreply, state}

  defp publish_response(channel, reply_to, correlation_id, response) do
    AMQP.Basic.publish(
      channel,
      "",
      reply_to,
      JSON.encode!(response),
      correlation_id: correlation_id,
      content_type: "application/json"
    )
  end
end
