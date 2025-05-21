# Stage 1: Build the application
FROM golang:1.24-alpine AS builder

# Set working directory
WORKDIR /app

# Copy go.mod and download dependencies
COPY go.mod ./
RUN go mod download

# Copy source code
COPY . .

# Build a statically linked binary with all optimizations
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -ldflags="-s -w" -o stocktax

# Stage 2: Create a minimal runtime image
FROM scratch

# Copy only the binary from the builder stage
COPY --from=builder /app/stocktax /stocktax

# Set the entry point
ENTRYPOINT ["/stocktax"] 