#!/bin/bash

echo "Starting the directory scan at path '$PARAM_STR_SOURCE'"
echo "Using exported Gitleaks args '$GITLEAKS_ARGS'"

eval gitleaks dir "$GITLEAKS_ARGS" "$PARAM_STR_SOURCE"
