# Use the official Rust image.
FROM rust:latest as builder

# Create a new empty shell project
WORKDIR /usr/src/actix-web
COPY ./Cargo.toml ./Cargo.toml

# This trick prevents rebuilding all dependencies if sources haven't changed.
RUN mkdir src/ && \
    echo "fn main() {println!(\"if you see this, the build broke\")}" > src/main.rs && \
    cargo build --release && \
    rm -f target/release/deps/soccer_meet_youtube*

# Now copy in our code
COPY . .

# Build for release.
RUN cargo build --release

# Final base
FROM debian:buster-slim
WORKDIR /root/
# Ensure to copy from the correct build directory
COPY --from=builder /usr/src/actix-web/target/release/soccer-meet-youtube .
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# The CMD should call your entry script which encapsulates migration and server start
CMD ["/usr/local/bin/entrypoint.sh"]
