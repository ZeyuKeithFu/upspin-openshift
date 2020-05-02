#!/usr/bin/env sh
set -e

exec & /upspin/upspinserver -tls_key /upspin/cert/upspin.k-apps.osh.massopen.cloud.key.pem -tls_cert /upspin/cert/upspin.k-apps.osh.massopen.cloud.crt.pem