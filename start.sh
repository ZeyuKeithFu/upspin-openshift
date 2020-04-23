#!/usr/bin/env sh
set -e

exec & /upspin/upspinserver -tls_cert /upspin/cert/upspin-openshift-infrastructure-as-code.k-apps.osh.massopen.cloud.crt -tls_key /upspin/cert/upspin-openshift-infrastructure-as-code.k-apps.osh.massopen.cloud.key