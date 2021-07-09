FROM rust:1.53 as builder

# Create dummy package
RUN USER=root cargo new --bin app
WORKDIR /app
ADD ./Cargo.toml .
ADD ./Cargo.lock .
RUN mkdir ./src/bin
RUN echo "fn main() {}" > ./src/bin/server.rs

# Cache dependencies
RUN cargo build --release

# Copy the rest of sources
RUN rm -rf src/*
COPY ./src ./src
COPY ./sqlx-data.json .
ENV SQLX_OFFLINE true

# Actual build
RUN ls src/bin
RUN cargo build --release

# Final image
FROM debian:buster-slim
COPY --from=builder /app/target/release/server /usr/bin/server
# COPY ./.env .
EXPOSE 8080
CMD ["server"]
