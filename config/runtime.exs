import Config

if config_env() == :prod do
  database_url =
    System.get_env("DATABASE_URL") ||
    raise """
    environment variable DATABASE_URL is missing.
    For example: ecto://USER:PASS@HOST/DATABASE
    """

  config :work_time_tracker, WorkTimeTracker.Repo,
    url: database_url,
    pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10"),
    socket_options: [:inet6]

  rabbitmq_url =
    System.get_env("RABBITMQ_URL") ||
    System.get_env("CLOUDAMQP_URL") ||
    "amqp://guest:guest@rabbitmq:5672"

  config :work_time_tracker, :rabbitmq,
    url: rabbitmq_url
end

if config_env() == :dev do
  # Override database hostname for Docker
  if System.get_env("DATABASE_URL") do
    config :work_time_tracker, WorkTimeTracker.Repo,
      url: System.get_env("DATABASE_URL"),
      pool_size: 10
  else
    # Use Docker service name when running in container
    postgres_host = System.get_env("POSTGRES_HOST") || "localhost"
    
    config :work_time_tracker, WorkTimeTracker.Repo,
      username: "postgres",
      password: "postgres",
      database: "work_time_tracker_dev",
      hostname: postgres_host,
      stacktrace: true,
      show_sensitive_data_on_connection_error: true,
      pool_size: 10
  end

  # Override RabbitMQ URL for Docker
  rabbitmq_host = System.get_env("RABBITMQ_HOST") || "localhost"
  
  config :work_time_tracker, :rabbitmq,
    url: "amqp://guest:guest@#{rabbitmq_host}:5672"
end

