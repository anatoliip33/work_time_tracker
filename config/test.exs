import Config

config :work_time_tracker, WorkTimeTracker.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "work_time_tracker_test",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: System.schedulers_online() * 2
