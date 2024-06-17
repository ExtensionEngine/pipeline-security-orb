#!/bin/bash

########### DEFAULTS ###########

# The `experimental` flag is needed for Semgrep to work, otherwise
# for unknown reason it will fail with exit code 2. This behavior
# is only observed in CI environment.
# When the `experimental` flag is set, saving the output to the
# file will not work and is just silently ignored.

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

BASELINE_COMMIT=""

if [ "$FULL_SCAN" -eq 0 ] && [[ "$GIT_BASE_BRANCH" = "$GIT_CURRENT_BRANCH" ]]; then
  # Usually when changes are merged back into a long-lived branch, e.g. trunk
  BASELINE_COMMIT=$(git rev-parse HEAD~1)
elif [ "$FULL_SCAN" -eq 0 ] && [[ "$GIT_BASE_BRANCH" != "$GIT_CURRENT_BRANCH" ]]; then
  # Usually a short-lived branch, in other words a pull request
  BASELINE_COMMIT="$(git rev-parse "$GIT_BASE_BRANCH")"
fi

if [[ -n $BASELINE_COMMIT ]]; then
  ARGS="$ARGS --baseline-commit $BASELINE_COMMIT"
fi

########### COMMAND ###########

echo "Running Semgrep scan, at path '$DIR_PATH', with following arguments:"
echo "$ARGS"

eval semgrep "$ARGS"
