#!/bin/bash

ARGS=()

read -ra ARGS <<<"${GITLEAKS_ARGS}"

echo "Starting the directory scan at path '${PWD}'"

set -x
gitleaks dir "${ARGS[@]}" .
set +x
