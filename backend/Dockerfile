FROM docker.io/library/rust:1-slim AS build
WORKDIR /src
COPY Cargo.toml ./
COPY src ./src
RUN cargo build --release

FROM docker.io/library/debian:bookworm-slim
COPY --from=build /src/target/release/backend /usr/local/bin/backend
EXPOSE 8080
CMD ["backend"]
