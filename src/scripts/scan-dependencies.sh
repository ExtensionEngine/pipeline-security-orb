#!/bin/bash

PARAM_STR_SCAN_COMMAND=$(circleci env subst "${PARAM_STR_SCAN_COMMAND}")

if [[ -n "${PARAM_STR_SCAN_COMMAND}" ]]; then
  echo "Running custom scan command: ${PARAM_STR_SCAN_COMMAND}"

  eval "${PARAM_STR_SCAN_COMMAND}"

elif [[ "${CURRENT_PKG_MANAGER}" == "npm" ]]; then
  echo "Running npm audit with high audit level omitting dev dependencies"

  npm audit --audit-level=high --omit=dev

elif [[ "${CURRENT_PKG_MANAGER}" == "pnpm" ]]; then
  echo "Running pnpm audit with high audit level on prod dependencies"

  pnpm audit --audit-level=high --prod

fi
