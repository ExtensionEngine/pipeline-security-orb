#!/bin/bash

if [[ -n "$SCAN_CMD" ]]; then
  echo "Running custom scan command: $SCAN_CMD"
  eval "$SCAN_CMD"
elif [[ "$PKG_MANAGER" == "npm" ]]; then
  echo "Running npm audit with high audit level omitting dev dependencies"
  npm audit --aduit-level=high --omit=dev
elif [[ "$PKG_MANAGER" == "pnpm" ]]; then
  echo "Running pnpm audit with high audit level on prod dependencies"
  pnpm audit --audit-level=high --prod
fi
