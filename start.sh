#!/usr/bin/env sh
set -e

exec & /upspin/upspinserver -tls_cert /upspin/cert/server.crt.pem -tls_key /upspin/cert/server.key.pem