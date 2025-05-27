#!/bin/bash

function install_semgrep() {
  local semgrep_arg
  local install_path

  [[ -n "${PARAM_STR_VERSION}" ]] && semgrep_arg="semgrep==${PARAM_STR_VERSION#v}" || semgrep_arg="semgrep"

  set -x
  # Installing without the '--user' flag results in the command not found error
  # due to issue how pip installed packages are added to the PATH in CI environments.
  # Adding the '--user' flag, (alongside the '--no-warn-script-location' to suppress
  # the location warnings) installs the package in a user specific directory which
  # is afterwards added to the PATH.
  python3 -m pip install --no-warn-script-location --user "${semgrep_arg}"
  set +x

  install_path="$(python3 -m site --user-base)/bin"

  echo "Adding Semgrep installation path (${install_path}) to the PATH"
  echo "export PATH=${install_path}:${PATH}" >>"${BASH_ENV}"
}

if ! command -v python3 >/dev/null 2>&1 || ! command -v pip3 >/dev/null 2>&1; then
  echo "Python 3 and Pip are required"
  exit 1
fi

if ! command -v semgrep >/dev/null 2>&1; then
  echo "Failed to detect Semgrep, installing..."

  install_semgrep
fi
