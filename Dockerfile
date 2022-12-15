# start with the official rust base image
# https://www.docker.com/blog/simplify-your-deployments-using-the-rust-official-image/
FROM rust AS chef

# Update the image and install compilers we'll need
RUN apt update && apt upgrade -y
RUN apt install -y g++-mingw-w64-x86-64 clang
RUN cargo install cargo-chef --locked

WORKDIR app

# using cargo chef, as described here: https://www.lpalmieri.com/posts/fast-rust-docker-builds/
FROM chef AS planner
COPY . .
RUN cargo chef prepare --recipe-path recipe.json

FROM chef AS builder
COPY --from=planner /app/recipe.json recipe.json
# Build dependencies - this is the caching Docker layer!
RUN cargo chef cook --release --target x86_64-unknown-linux-gnu --recipe-path recipe.json
# Build application
COPY . .
RUN cargo build --release --target x86_64-unknown-linux-gnu --bin server

# We do not need the Rust toolchain to run the binary!
FROM debian:bullseye-slim AS runtime
WORKDIR app
COPY --from=builder /app/target/x86_64-unknown-linux-gnu/release/server /usr/local/bin
ENTRYPOINT ["/usr/local/bin/server"]