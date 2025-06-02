import Config

config :work_time_tracker, WorkTimeTracker.Repo,
  username: "postgres",
  password: "postgres",
  database: "work_time_tracker_dev",
  hostname: "localhost",
  stacktrace: true,
  show_sensitive_data_on_connection_error: true,
  pool_size: 10
