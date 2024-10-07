#!/bin/bash

echo "Starting the Dockerfile scan at directory '${PWD}'"

set -x
trivy \
  config \
  . \
  --severity "${PARAM_STR_SEVERITY}" \
  --misconfig-scanners dockerfile \
  --skip-check-update \
  --exit-code 2
set +x
