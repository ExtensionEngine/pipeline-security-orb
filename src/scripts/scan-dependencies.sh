#!/bin/bash

if [[ -n "$SCAN_CMD" ]]; then
  echo "Running custom scan command: $SCAN_CMD"

  eval "$SCAN_CMD"

elif [[ "$CURRENT_PKG_MANAGER" == "npm" ]]; then
  echo "Running npm audit with high audit level omitting dev dependencies"

  npm audit --audit-level=high --omit=dev

elif [[ "$CURRENT_PKG_MANAGER" == "pnpm" ]]; then
  echo "Running pnpm audit with high audit level on prod dependencies"

  pnpm audit --audit-level=high --prod

fi
