defmodule WorkTimeTracker.Repo do
  use Ecto.Repo,
    otp_app: :work_time_tracker,
    adapter: Ecto.Adapters.Postgres
end
