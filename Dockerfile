FROM rust:latest as build

# create a new empty shell project
RUN USER=root cargo new --bin actix-crud-api
WORKDIR /actix-crud-api

# copy over your manifests
COPY ./Cargo.lock ./Cargo.lock
COPY ./Cargo.toml ./Cargo.toml

# this build step will cache your dependencies
RUN cargo build --release
RUN rm src/*.rs

# copy your source tree
COPY ./src ./src

# build for release
RUN rm ./target/release/deps/*
RUN cargo build --release

# our final base
FROM rust:latest

# copy the build artifact from the build stage
COPY --from=build /actix-crud-api/target/release/actix-crud-api .

# set the startup command to run your binary
CMD ["./actix-crud-api"]