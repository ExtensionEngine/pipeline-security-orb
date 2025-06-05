#!/bin/bash

if [[ -z "${PARAM_STR_IMAGE}" ]]; then
  echo "Specify image and retry."

  exit 1
fi

PARAM_STR_IMAGE=$(circleci env subst "${PARAM_STR_IMAGE}")

IMAGE_SOURCE="docker"

if [[ "${PARAM_STR_IMAGE}" == *.tar ]]; then
  IMAGE_SOURCE="docker-archive"
fi

SBOM_ARGS=("${IMAGE_SOURCE}:${PARAM_STR_IMAGE}")
SBOM_ARGS+=("-o" "${PARAM_ENUM_FORMAT}=${PARAM_STR_OUT_PATH}")

if [[ -n "${PARAM_STR_EXCLUDE}" ]]; then
  set -f # Disable glob expansion
  for exclude_glob in ${PARAM_STR_EXCLUDE}; do
    SBOM_ARGS+=("--exclude=$exclude_glob")
  done
  set +f
fi

set -x
syft "${SBOM_ARGS[@]}"
set +x
