#!/bin/bash

EVAL_GITLEAKS_ARGS=$(eval echo "${GITLEAKS_ARGS}")

echo "Starting the repository scan at path '$PARAM_STR_SOURCE'"
echo "Using exported Gitleaks args '$GITLEAKS_ARGS'"
echo "Using '$GIT_BASE_BRANCH' as the base branch"
echo "Using '$GIT_CURRENT_BRANCH' as the current branch"

if [[ "$GIT_BASE_BRANCH" = "$GIT_CURRENT_BRANCH" ]]; then
  # Usually when changes are merged back into a long-lived branch, e.g. trunk
  LOG_OPTS="$PARAM_STR_BASE_REVISION^..$CIRCLE_SHA1"

  echo "The base branch is the current branch"

  if [[ -z "$PARAM_STR_BASE_REVISION" ]] || ! git cat-file -e "$PARAM_STR_BASE_REVISION"; then
    LOG_OPTS="HEAD~1^..$CIRCLE_SHA1"

    echo "The base revision is empty or invalid"
    echo "Using HEAD~1 as the base revision"

  elif [[ "$PARAM_STR_BASE_REVISION" == "$CIRCLE_SHA1" ]]; then
    LOG_OPTS=-1

    echo "The base revision is the current revision"
    echo "Scanning only last commit"

  fi

  EVAL_GITLEAKS_ARGS="$GITLEAKS_ARGS --log-opts=$LOG_OPTS"

else
  # Usually a short lived branch, that is a pull request
  echo "The base branch is not the current branch"
  echo "Scanning all the commits in the current branch '$GIT_CURRENT_BRANCH'"

  EVAL_GITLEAKS_ARGS="$GITLEAKS_ARGS --log-opts=$GIT_BASE_BRANCH..$GIT_CURRENT_BRANCH"

fi

set -x
eval gitleaks git "$EVAL_GITLEAKS_ARGS" "$PARAM_STR_SOURCE"
set +x
