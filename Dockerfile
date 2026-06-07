FROM rust:bullseye AS builder
WORKDIR /usr/src

RUN git clone https://github.com/tpmanley/mdns-responder.git && \
    cargo install --path mdns-responder --force
RUN cargo install http-tunnel

# Copy the statically-linked binary into a scratch container.
FROM rust:slim-bullseye
WORKDIR /usr/local/bin
COPY --from=builder /usr/local/cargo/bin/http-tunnel .
COPY --from=builder /usr/local/cargo/bin/mdns-responder .
COPY script.sh .
USER 1000
CMD ./script.sh
