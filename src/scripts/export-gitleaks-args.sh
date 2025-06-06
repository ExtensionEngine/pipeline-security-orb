#!/bin/bash

ARGS="--log-level=debug --verbose --redact --exit-code=2"

if [[ -n "${PARAM_STR_CONFIG_FILE}" ]]; then
  ARGS="${ARGS} --config=${PARAM_STR_CONFIG_FILE}"
fi

if [[ -n "${PARAM_STR_BASELINE_REPORT}" ]]; then
  ARGS="${ARGS} --baseline-path=${PARAM_STR_BASELINE_REPORT}"
fi

echo "export GITLEAKS_ARGS='${ARGS}'" >>"${BASH_ENV}"
