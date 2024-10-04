#!/bin/bash

echo "Starting the directory scan at path '${PARAM_STR_SOURCE}'"

set -x
eval gitleaks dir "${GITLEAKS_ARGS}" "${PARAM_STR_SOURCE}"
set +x
