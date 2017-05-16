#!/bin/sh
# Used to enter build environment and manually build/rebuild/test packages

_BASE="$(pwd)"

_OPWD=$(pwd)
cd "${_BASE}"
source "${_BASE}/config.sh"
source "${_BASE}/_build_vars.sh"
source "${_BASE}/_build_dirs.sh"
cd "${_OPWD}"

echo "${TARGET} environment setup: ${PATH}"
PS1='R2['${TARGET}'] % ' exec sh -i
