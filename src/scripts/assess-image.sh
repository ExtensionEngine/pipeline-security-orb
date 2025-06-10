#!/bin/bash

if [[ -z "${PARAM_STR_IMAGE}" ]]; then
  echo "Specify image and retry."

  exit 1
fi

PARAM_STR_IMAGE=$(circleci env subst "${PARAM_STR_IMAGE}")

function scan_secrets() {
  local args=(image "--scanners=secret" "--image-config-scanners=secret")

  if [[ "${PARAM_STR_IMAGE}" == *.tar ]]; then
    args+=(--input)
  fi

  args+=("${PARAM_STR_IMAGE}")

  set -x
  trivy "${args[@]}"
  set +x
}

function scan_vuln() {
  local args=()

  if [[ "${PARAM_STR_IMAGE}" == *.tar ]]; then
    args+=("docker-archive:${PARAM_STR_IMAGE}")
  else
    args+=("docker:${PARAM_STR_IMAGE}")
  fi

  if [[ -n "${PARAM_STR_IGNORE_FIX_STATUS}" ]]; then
    args+=("--ignore-states=${PARAM_STR_IGNORE_FIX_STATUS}")
  fi

  if [[ -n "${PARAM_STR_EXCLUDE}" ]]; then
    set -f # Disable glob expansion
    for exclude_glob in ${PARAM_STR_EXCLUDE}; do
      args+=("--exclude=$exclude_glob")
    done
    set +f
  fi

  args+=(--by-cve "--fail-on=${PARAM_ENUM_SEVERITY}")
  args+=("--output=sarif")
  args+=("--file=${PARAM_STR_OUT_VULN_PATH}")

  set -x
  grype "${args[@]}"
  set +x
}

set -f # Disable glob expansion
for scanner in ${PARAM_STR_SCANNERS}; do
  if [[ $scanner == "vuln" ]]; then
    scan_vuln
  elif [[ $scanner == "secret" ]]; then
    scan_secrets
  else
    echo "Unknown image scanner: $scanner"
    exit 1
  fi
done
set +f
