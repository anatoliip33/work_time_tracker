defmodule WorkTimeTracker.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      WorkTimeTracker.Repo,
      WorkTimeTracker.Rpc.Server
    ]

    opts = [strategy: :one_for_one, name: WorkTimeTracker.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
