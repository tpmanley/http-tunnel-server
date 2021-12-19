#!/bin/bash

./http-tunnel --bind 0.0.0.0:8090 http &

./mdns-responder -p 8090 -n "My HTTP Tunnel" -v -v _httptunnel._tcp &

# Wait for any process to exit
wait -n

# Exit with status of process that exited first
exit $?