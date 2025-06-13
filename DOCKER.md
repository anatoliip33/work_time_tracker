# Docker Setup for Work Time Tracker

This guide explains how to run the Work Time Tracker application using Docker and Docker Compose.

## Prerequisites

- Docker
- Docker Compose

## Services

The application stack includes:

- **PostgreSQL**: Database server (port 5432)
- **RabbitMQ**: Message broker (port 5672, management UI on 15672)
- **Work Time Tracker**: Main application (port 4000)

## Quick Start

1. **Start the entire stack:**
   ```bash
   docker-compose up
   ```

2. **Start in detached mode:**
   ```bash
   docker-compose up -d
   ```

3. **View logs:**
   ```bash
   docker-compose logs -f app
   ```

4. **Stop the stack:**
   ```bash
   docker-compose down
   ```

## Development Workflow

### Building the Application

```bash
# Build only the app image
docker-compose build app

# Force rebuild without cache
docker-compose build --no-cache app
```

### Database Operations

```bash
# Run database migrations
docker-compose exec app mix ecto.migrate

# Reset database
docker-compose exec app mix ecto.reset

# Create database
docker-compose exec app mix ecto.create
```

### Interactive Shell

```bash
# Access application container shell
docker-compose exec app sh

# Run Elixir interactive shell
docker-compose exec app iex -S mix
```

### Running Tests

```bash
# Run tests
docker-compose exec app mix test
```

## Accessing Services

- **Application**: http://localhost:4000
- **RabbitMQ Management**: http://localhost:15672 (guest/guest)
- **PostgreSQL**: localhost:5432 (postgres/postgres)

## Environment Variables

You can customize the application by setting environment variables:

- `DATABASE_URL`: Override database connection
- `RABBITMQ_URL`: Override RabbitMQ connection
- `MIX_ENV`: Set environment (dev/test/prod)
- `POOL_SIZE`: Database connection pool size

## Troubleshooting

### Database Connection Issues

```bash
# Check if PostgreSQL is ready
docker-compose exec postgres pg_isready -U postgres

# View PostgreSQL logs
docker-compose logs postgres
```

### RabbitMQ Connection Issues

```bash
# Check RabbitMQ status
docker-compose exec rabbitmq rabbitmq-diagnostics ping

# View RabbitMQ logs
docker-compose logs rabbitmq
```

### Application Issues

```bash
# View application logs
docker-compose logs app

# Restart just the application
docker-compose restart app
```

### Clean Reset

```bash
# Stop and remove all containers, networks, and volumes
docker-compose down -v

# Remove all images
docker-compose down --rmi all

# Start fresh
docker-compose up --build
```

## Production Deployment

For production deployment, consider:

1. **Environment-specific configuration:**
   ```bash
   # Use production compose file
   docker-compose -f docker-compose.yml -f docker-compose.prod.yml up
   ```

2. **External database and message broker:**
   - Use managed PostgreSQL service
   - Use managed RabbitMQ service
   - Set appropriate environment variables

3. **Security considerations:**
   - Change default passwords
   - Use environment variables for secrets
   - Enable SSL/TLS connections
   - Configure firewall rules

## File Structure

```
.
├── Dockerfile              # Application container definition
├── docker-compose.yml      # Development stack definition
├── .dockerignore           # Files to ignore during build
├── config/
│   └── runtime.exs         # Runtime configuration for Docker
└── DOCKER.md              # This documentation
```

