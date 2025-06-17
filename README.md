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

## Docker

This project includes Docker configuration for both development and testing environments.

### Docker Files Overview

- `Dockerfile` - Multi-stage build for app and test environments
- `docker-compose.yml` - Main application stack (app, PostgreSQL, RabbitMQ)
- `docker-compose.test.yml` - Testing environment with isolated services

### Running the Application with Docker

1. **Start the application stack:**

   ```bash
   docker-compose up
   ```

   This starts:
   - Work Time Tracker application (http://localhost:4000)
   - PostgreSQL database (localhost:5432)
   - RabbitMQ with management UI (http://localhost:15672)

2. **Run in background:**

   ```bash
   docker-compose up -d
   ```

3. **Stop the application:**

   ```bash
   docker-compose down
   ```

### Running Tests with Docker

1. **Run tests once:**

   ```bash
   docker-compose -f docker-compose.test.yml run --rm test
   ```

2. **Build test image (if needed):**

   ```bash
   docker-compose -f docker-compose.test.yml build test
   ```

### Available Services

| Service | URL | Credentials |
|---------|-----|-------------|
| Application | http://localhost:4000 | - |
| PostgreSQL | localhost:5432 | postgres/postgres |
| RabbitMQ Management | http://localhost:15672 | guest/guest |
| RabbitMQ (Test) | localhost:5673 | guest/guest |
| PostgreSQL (Test) | localhost:5433 | postgres/postgres |

### Development Workflow

```bash
# Start development environment
docker-compose up -d

# Run tests
docker-compose -f docker-compose.test.yml run --rm test

# View logs
docker-compose logs -f app

# Access running container
docker-compose exec app sh

# Clean up
docker-compose down -v
```