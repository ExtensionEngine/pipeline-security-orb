#!/bin/bash

BASE_BRANCH=$(git rev-parse --abbrev-ref origin/HEAD | cut -c8-)
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)

if [[ -n $BASE_BRANCH_OVERRIDE ]]; then
  BASE_BRANCH=$BASE_BRANCH_OVERRIDE
fi

if [[ -n $CIRCLE_BRANCH ]]; then
  CURRENT_BRANCH=$CIRCLE_BRANCH
fi

echo "export GIT_BASE_BRANCH='$BASE_BRANCH'" >> "$BASH_ENV"
echo "export GIT_CURRENT_BRANCH='$CURRENT_BRANCH'" >> "$BASH_ENV"
