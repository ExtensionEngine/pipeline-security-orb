#!/bin/bash

EVAL_GITLEAKS_ARGS=$(eval echo "${GITLEAKS_ARGS}")
LOG_OPTS=""

echo "Using '${GIT_BASE_BRANCH}' as the base branch"
echo "Using '${GIT_CURRENT_BRANCH}' as the current branch"

if [[ "${GIT_BASE_BRANCH}" = "${GIT_CURRENT_BRANCH}" ]]; then
  # Usually when changes are merged back into a long-lived branch, e.g. trunk
  LOG_OPTS="${PARAM_STR_BASE_REVISION}^..${CIRCLE_SHA1}"

  if [[ -z "${PARAM_STR_BASE_REVISION}" ]] || ! git cat-file -e "${PARAM_STR_BASE_REVISION}"; then
    LOG_OPTS="HEAD~1^..${CIRCLE_SHA1}"

    echo "The base revision is empty or invalid"
    echo "Scanning using 'HEAD~1' as the base revision"

  elif [[ "${PARAM_STR_BASE_REVISION}" == "${CIRCLE_SHA1}" ]]; then
    LOG_OPTS=-1

    echo "The base revision is the current revision"
    echo "Scanning only last commit"

  else
    echo "Scanning using the provided base revision '${PARAM_STR_BASE_REVISION}'"

  fi

else
  # Usually a short lived branch, that is a pull request
  echo "Scanning all the commits in the current branch '${GIT_CURRENT_BRANCH}'"

  LOG_OPTS="${GIT_BASE_BRANCH}..${GIT_CURRENT_BRANCH}"

fi

EVAL_GITLEAKS_ARGS="${EVAL_GITLEAKS_ARGS} --log-opts=${LOG_OPTS}"

set -x
eval gitleaks git "${EVAL_GITLEAKS_ARGS}" "${PARAM_STR_SOURCE}"
set +x
