FROM rust:1.56 AS build
WORKDIR /usr/src

RUN cargo install --git "https://github.com/tpmanley/mdns-responder.git"
RUN cargo install http-tunnel

# Copy the statically-linked binary into a scratch container.
FROM rust:1.56-slim-buster
WORKDIR /usr/local/bin
COPY --from=build /usr/local/cargo/bin/http-tunnel .
COPY --from=build /usr/local/cargo/bin/mdns-responder .
COPY script.sh .
USER 1000
CMD ./script.sh
