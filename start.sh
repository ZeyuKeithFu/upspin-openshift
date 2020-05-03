#!/usr/bin/env sh
set -e

exec & /home/upspin/upspinserver -tls_key /home/upspin/cert/upspin.k-apps.osh.massopen.cloud.key.pem -tls_cert /home/upspin/cert/upspin.k-apps.osh.massopen.cloud.crt.pem