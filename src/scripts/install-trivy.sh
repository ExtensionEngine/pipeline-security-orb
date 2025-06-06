#!/bin/bash

BASE_URL="https://raw.githubusercontent.com/aquasecurity/trivy"
INSTALL_SCRIPT_URL="${BASE_URL}/main/contrib/install.sh"
TRIVY_DEST_DIR="${TRIVY_DEST_DIR:-/usr/local/bin}"

function install_trivy() {
  local script_args=(-b "${TRIVY_DEST_DIR}")

  if [[ -n "${PARAM_STR_VERSION}" ]]; then
    script_args+=("${PARAM_STR_VERSION}")
  fi

  set -x
  curl -sfL --retry 1 "${INSTALL_SCRIPT_URL}" | sudo sh -s -- "${script_args[@]}"
  set +x

  echo "Installed trivy ${PARAM_STR_VERSION:-latest} at ${TRIVY_DEST_DIR}"
}

if ! command -v trivy >/dev/null 2>&1; then
  echo "Failed to detect trivy, installing..."

  install_trivy
fi
