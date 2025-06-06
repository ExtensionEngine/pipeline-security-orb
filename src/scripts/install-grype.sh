#!/bin/bash

BASE_URL="https://raw.githubusercontent.com/anchore/grype"
INSTALL_SCRIPT_URL="${BASE_URL}/main/install.sh"
GRYPE_DEST_DIR="${GRYPE_DEST_DIR:-/usr/local/bin}"

function install_grype() {
  local script_args=(-b "${GRYPE_DEST_DIR}")

  if [[ -n "${PARAM_STR_VERSION}" ]]; then
    script_args+=("${PARAM_STR_VERSION}")
  fi

  set -x
  curl -sfL --retry 1 "${INSTALL_SCRIPT_URL}" | sudo sh -s -- "${script_args[@]}"
  set +x

  echo "Installed grype ${PARAM_STR_VERSION:-latest} at ${GRYPE_DEST_DIR}"
}

if ! command -v grype >/dev/null 2>&1; then
  echo "Failed to detect grype, installing..."

  install_grype
fi
