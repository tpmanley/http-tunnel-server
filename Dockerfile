FROM rust:bookworm AS builder
WORKDIR /usr/src

RUN cargo install --git "https://github.com/tpmanley/mdns-responder.git" mdns-responder --force
RUN cargo install http-tunnel

# Copy the statically-linked binary into a scratch container.
FROM rust:slim-bookworm
WORKDIR /usr/local/bin
COPY --from=builder /usr/local/cargo/bin/http-tunnel .
COPY --from=builder /usr/local/cargo/bin/mdns-responder .
COPY script.sh .
USER 1000
CMD ./script.sh
