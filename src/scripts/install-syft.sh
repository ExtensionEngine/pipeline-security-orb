#!/bin/bash

BASE_URL="https://raw.githubusercontent.com/anchore/syft"
INSTALL_SCRIPT_URL="${BASE_URL}/main/install.sh"
SYFT_DEST_DIR="${SYFT_DEST_DIR:-/usr/local/bin}"

function install_syft() {
  local script_args=(-b "${SYFT_DEST_DIR}")

  if [[ -n "${PARAM_STR_VERSION}" ]]; then
    script_args+=("${PARAM_STR_VERSION}")
  fi

  set -x
  curl -sfL --retry 1 "${INSTALL_SCRIPT_URL}" | sudo sh -s -- "${script_args[@]}"
  set +x

  echo "Installed syft ${PARAM_STR_VERSION:-latest} at ${SYFT_DEST_DIR}"
}

if ! command -v syft >/dev/null 2>&1; then
  echo "Failed to detect syft, installing..."

  install_syft
fi
