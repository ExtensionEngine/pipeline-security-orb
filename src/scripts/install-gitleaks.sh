#!/bin/bash

OS=$(uname | sed 's/Darwin/darwin/;s/Linux/linux/')
ARCH=$(uname -m | sed 's/x86_64/x64/;s/aarch64/arm64/')
GL_DEST_DIR="${GL_DEST_DIR:-/usr/local/bin}"
BASE_URL="https://github.com/gitleaks/gitleaks"

function get_release_url() {
  local release_url
  local version

  if [[ -n "${PARAM_STR_VERSION}" ]]; then
    version="${PARAM_STR_VERSION}"
  else
    version=$(curl -s https://api.github.com/repos/gitleaks/gitleaks/releases/latest | jq -r .tag_name)
  fi

  release_url="${BASE_URL}/releases/download/${version}/gitleaks_${version#v}_${OS}_${ARCH}.tar.gz"

  echo "${release_url}"
}

function install_gitleaks() {
  local work_dir
  local temp_dir
  local release_url

  work_dir=$(pwd)
  temp_dir=$(mktemp -d 'tmp.XXXXX')
  release_url=$(get_release_url)

  cd "${temp_dir}" || exit 1

  set -x
  curl -sfL --retry 1 "${release_url}" | tar zx
  sudo install "gitleaks" "${GL_DEST_DIR}"
  set +x

  echo "Installed $(gitleaks --version) at $(command -v gitleaks)"

  cd "${work_dir}" || exit 1
  rm -rf "${temp_dir}"
}

if ! command -v gitleaks >/dev/null 2>&1; then
  echo "Failed to detect gitleaks, installing..."

  install_gitleaks
fi
