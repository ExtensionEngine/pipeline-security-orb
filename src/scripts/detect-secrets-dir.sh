#!/bin/bash

echo "Starting the directory scan at path '${PWD}'"

set -x
eval \
  gitleaks \
  dir \
  "${GITLEAKS_ARGS}" \
  .
set +x
