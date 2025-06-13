# Use the official Elixir image
FROM elixir:1.18-alpine

# Install build dependencies
RUN apk add --no-cache build-base git

# Create app directory
WORKDIR /app

# Install hex and rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# Copy mix files
COPY mix.exs mix.lock ./

# Install dependencies
RUN mix deps.get

# Copy application code
COPY . .

# Compile the application
RUN mix compile

# Expose port (if needed for future web interface)
EXPOSE 4000

# Default command
CMD ["mix", "run", "--no-halt"]

