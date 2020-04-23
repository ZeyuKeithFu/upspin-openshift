#!/usr/bin/env sh
set -e

exec & /upspin/upspinserver -tls_cert /upspin/cert/server.pem -tls_key /upspin/cert/server.key