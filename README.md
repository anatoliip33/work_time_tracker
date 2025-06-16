# WorkTimeTracker

## Description

This is a work time tracking application built with Elixir. It utilizes PostgreSQL for data storage and RabbitMQ for inter-process communication via RPC.

## Features

- User management
- Card management (NFC cards)
- Work time tracking
- RPC interface for communication

## Installation

### Prerequisites

- Elixir (version 1.16 or higher)
- Erlang/OTP (compatible with your Elixir version)
- PostgreSQL
- RabbitMQ

### Setup

1. Clone the repository:

   ```bash
   git clone https://github.com/anatoliip33/work_time_tracker.git
   cd work_time_tracker
   ```

2. Install dependencies:

   ```bash
   mix deps.get
   ```

3. Configure your database connection in `config/dev.exs` and `config/test.exs`.

4. Create and migrate the database:

   ```bash
   mix ecto.setup
   ```

5. Configure your RabbitMQ connection in `config/config.exs`.

## Running the Application

To start the application:

```bash
mix run --no-halt
```

This will start the application supervisor, including the database connection and RPC server.

## Running Tests

To run the test suite:

```bash
mix test
```

## Docker

This project includes a `Dockerfile` and `docker-compose.yml` for containerization.

### Build and Run with Docker Compose

1. Build the Docker images:

   ```bash
   docker compose build
   ```

2. Start the services (Postgres, RabbitMQ, and App):

   ```bash
   docker compose up
   ```
