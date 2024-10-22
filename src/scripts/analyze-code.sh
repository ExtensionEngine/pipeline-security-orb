#!/bin/bash

# The `experimental` flag is needed for Semgrep to work, otherwise
# for unknown reason it will fail with exit code 2. This behavior
# is only observed in CI environment.
# When the `experimental` flag is set, saving the output to the
# file will not work and is just silently ignored.
ARGS="--experimental --error --strict --metrics off"
BASELINE_COMMIT=""

function join() {
  local separator="$1"
  shift
  local first="$1"
  shift
  printf "%s" "${first}" "${@/#/$separator}"
}

IFS=' ' read -ra RULE_ARRAY <<< "${PARAM_STR_RULES}"
ARGS="${ARGS} --config $(join ' --config ' "${RULE_ARRAY[@]}")"

if [ "${PARAM_BOOL_VERBOSE}" -eq 1 ]; then
  ARGS="${ARGS} --verbose"
fi

if [ "${PARAM_BOOL_FULL_SCAN}" -eq 0 ]; then
  echo "Using '${GIT_BASE_BRANCH}' as the base branch"
  echo "Using '${GIT_CURRENT_BRANCH}' as the current branch"

  if [[ "${GIT_BASE_BRANCH}" = "${GIT_CURRENT_BRANCH}" ]]; then
    # Usually when changes are merged back into a long-lived branch, e.g. trunk
    BASELINE_COMMIT=$(git rev-parse HEAD~1)

    echo "Scanning diff after the baseline 'HEAD~1'"
  else
    # Usually a short-lived branch, in other words a pull request
    BASELINE_COMMIT="$(git rev-parse "${GIT_BASE_BRANCH}")"

    echo "Scanning diff introduced by the current branch '${GIT_CURRENT_BRANCH}'"
  fi
else
  echo "Scanning entire codebase"
fi

if [[ -n ${BASELINE_COMMIT} ]]; then
  ARGS="${ARGS} --baseline-commit ${BASELINE_COMMIT}"
fi

set -x
eval semgrep "${ARGS}"
set +x
