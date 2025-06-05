import Config

config :work_time_tracker,
  ecto_repos: [WorkTimeTracker.Repo],
  generators: [timestamp_type: :utc_datetime]

config :work_time_tracker, :rabbitmq,
  url: "amqp://guest:guest@localhost:5672"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
