FROM debian:bookworm-slim as builder

# Install build dependencies
RUN apt-get update && \
    apt-get install -y curl build-essential clang libclang-dev pkg-config git ca-certificates && \
    curl https://sh.rustup.rs -sSf | bash -s -- -y && \
    . $HOME/.cargo/env && \
    rustup default stable

WORKDIR /app
COPY . /app
WORKDIR /app/minimal

# Build the minimal binary
RUN . $HOME/.cargo/env && cargo build --release --bin minimal

FROM debian:bookworm-slim
WORKDIR /app
COPY --from=builder /app/target/release/minimal /usr/local/bin/minimal
ENTRYPOINT ["/usr/local/bin/minimal"]