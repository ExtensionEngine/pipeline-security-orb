#!/bin/bash

########### DEFAULTS ###########

ARGS="--experimental --error --strict --metrics off"

########### VERBOSE ###########

if [ "$VERBOSE" -eq 1 ]; then
  ARGS="$ARGS --verbose"
fi

########### CONFIG ###########

function join() {
  local separator="$1"
  shift
  local first="$1"
  shift
  printf "%s" "$first" "${@/#/$separator}"
}

IFS=' ' read -ra RULE_ARRAY <<< "$RULES"

ARGS="$ARGS --config $(join ' --config ' "${RULE_ARRAY[@]}")"

########### BASELINE COMMIT ###########

BASE_BRANCH=$(git rev-parse --abbrev-ref origin/HEAD | cut -c8-)
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)

if [[ -n $BASE_BRANCH_OVERRIDE ]]; then
  BASE_BRANCH=$BASE_BRANCH_OVERRIDE
fi

if [[ -n $CIRCLE_BRANCH ]]; then
  CURRENT_BRANCH=$CIRCLE_BRANCH
fi

BASELINE_COMMIT=""

if [ "$FULL_SCAN" -eq 0 ] && [[ "$BASE_BRANCH" = "$CURRENT_BRANCH" ]]; then
  # Usually when changes are merged back into a long-lived branch, e.g. trunk
  BASELINE_COMMIT=$(git rev-parse HEAD~1)
elif [ "$FULL_SCAN" -eq 0 ] && [[ "$BASE_BRANCH" != "$CURRENT_BRANCH" ]]; then
  # Usually a short-lived branch, in other words a pull request
  BASELINE_COMMIT="$(git rev-parse "$BASE_BRANCH")"
fi

if [[ -n $BASELINE_COMMIT ]]; then
  ARGS="$ARGS --baseline-commit $BASELINE_COMMIT"
fi

########### COMMAND ###########

echo "Running Semgrep scan, at path '$DIR_PATH', with following arguments:"
echo "$ARGS"

eval semgrep "$ARGS"
