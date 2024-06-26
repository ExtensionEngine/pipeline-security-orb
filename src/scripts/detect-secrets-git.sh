#!/bin/bash

echo "Starting the repository scan at path '$REPO_PATH'"
echo "Using exported Gitleaks args '$GITLEAKS_ARGS'"
echo "Using '$GIT_BASE_BRANCH' as the base branch"
echo "Using '$GIT_CURRENT_BRANCH' as the current branch"

if [[ "$GIT_BASE_BRANCH" = "$GIT_CURRENT_BRANCH" ]]; then
  # Usually when changes are merged back into a long-lived branch, e.g. trunk
  echo "The base branch is the current branch"
  LOG_OPTS="$BASE_REVISION^..$CIRCLE_SHA1"

  if [[ -z "$BASE_REVISION" ]] || ! git cat-file -e "$BASE_REVISION"; then
    echo "The base revision is empty or invalid"
    echo "Using HEAD~1 as the base revision"
    LOG_OPTS="HEAD~1^..$CIRCLE_SHA1"
  elif [[ "$BASE_REVISION" == "$CIRCLE_SHA1" ]]; then
    echo "The base revision is the current revision"
    echo "Scanning only last commit"
    LOG_OPTS=-1
  fi

  eval gitleaks "$GITLEAKS_ARGS" --log-opts="$LOG_OPTS"
else
  # Usually a short lived branch, that is a pull request
  echo "The base branch is not the current branch"
  echo "Scanning all the commits in the current branch '$GIT_CURRENT_BRANCH'"
  eval gitleaks "$GITLEAKS_ARGS" --log-opts="$GIT_BASE_BRANCH..$GIT_CURRENT_BRANCH"
fi
