#!/bin/bash

echo "Starting the directory scan at path '$DIR_PATH'"
echo "Using exported gitleaks args '$GITLEAKS_ARGS'"
eval gitleaks "$GITLEAKS_ARGS" --no-git
