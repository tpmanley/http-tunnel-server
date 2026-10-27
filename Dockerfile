FROM rust:bookworm AS builder
WORKDIR /usr/src

RUN cargo install --git "https://github.com/tpmanley/mdns-responder.git" mdns-responder --force
RUN cargo install http-tunnel

# Copy the statically-linked binary into a scratch container.
FROM rust:slim-bookworm
RUN apt-get update && apt-get install -y --no-install-recommends stunnel4 ca-certificates \
    && rm -rf /var/lib/apt/lists/*
WORKDIR /usr/local/bin
COPY --from=builder /usr/local/cargo/bin/http-tunnel .
COPY --from=builder /usr/local/cargo/bin/mdns-responder .
COPY script.sh stunnel.conf ./
USER 1000
CMD ./script.sh
