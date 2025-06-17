ARG ELIXIR_VERSION=1.18

FROM elixir:${ELIXIR_VERSION}-alpine AS base

RUN apk add --no-cache build-base git postgresql-client
WORKDIR /app
RUN mix local.hex --force && mix local.rebar --force
COPY mix.exs mix.lock ./
COPY config config

# Development image
FROM base AS app
ENV MIX_ENV=dev
RUN mix deps.get
RUN mix compile
EXPOSE 4000
COPY . .
CMD ["mix", "run", "--no-halt"]

# Test image
FROM base AS test
ENV MIX_ENV=test
RUN mix deps.get
RUN mix compile
COPY . .
CMD ["mix", "test"]
