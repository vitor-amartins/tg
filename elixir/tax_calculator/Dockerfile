 # Stage 1: Build the Elixir application
FROM hexpm/elixir:1.18.0-erlang-26.0.2-alpine-3.19.1 AS builder

# Set environment variables
ENV MIX_ENV=prod

# Install build dependencies
RUN apk add --no-cache build-base git

# Create app directory and copy the Elixir application
WORKDIR /app
COPY mix.exs mix.lock ./
COPY lib lib
COPY config config || true

# Get dependencies
RUN mix local.hex --force && \
    mix local.rebar --force && \
    mix deps.get --only prod && \
    mix deps.compile

# Build and generate a release
RUN mix escript.build

# Stage 2: Create a minimal runtime image
FROM alpine:3.19.1

# Install runtime dependencies - only what's needed to run the application
RUN apk add --no-cache ncurses-libs libstdc++ libgcc

# Set working directory
WORKDIR /app

# Copy the built escript from the builder stage
COPY --from=builder /app/tax_calculator .

# Make the escript executable
RUN chmod +x tax_calculator

# Set the entrypoint to the executable
ENTRYPOINT ["./tax_calculator"]