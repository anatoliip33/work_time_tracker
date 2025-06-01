defmodule WorkTimeTracker.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Starts a worker by calling: WorkTimeTracker.Worker.start_link(arg)
      # {WorkTimeTracker.Worker, arg}
    ]

    opts = [strategy: :one_for_one, name: WorkTimeTracker.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
