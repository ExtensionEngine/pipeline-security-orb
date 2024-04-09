#!/bin/bash

REPORT="--report-format=sarif --report-path=/tmp/gitleaks-report.sarif"
ARGS="detect --source . --log-level=debug --verbose --redact $REPORT --exit-code=2"

if [[ -n "$CONFIG_FILE" ]]; then
  ARGS="$ARGS --config=$CONFIG_FILE"
fi

if [[ -n "$BASELINE_REPORT" ]]; then
  ARGS="$ARGS --baseline-path=$BASELINE_REPORT"
fi

echo "export GITLEAKS_ARGS='$ARGS'" >> "$BASH_ENV"
