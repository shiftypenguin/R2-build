#!/bin/sh

source ./config.sh
source ./_build_vars.sh
source ./_build_dirs.sh

# repeat cleanup
if [ -n "${ROOTDIR}" ]; then
	fork rm -r "${ROOTDIR}${USRDIR}/share/info" "${ROOTDIR}${USRDIR}/info"
	find "${ROOTDIR}" -type f -name "*.la" -delete
fi

_flag=-g
if [ -n "${STRIP_RESULT}" ]; then
	[ "${STRIP_RESULT}" == "S" ] && _flag=-s
	find "${ROOTDIR}" -type f -exec ${TARGET}-strip -p ${_flag} '{}' '+'
fi

_flag=
if [ -n "${TOUCH_RESULT}" ]; then
	[ "${TOUCH_RESULT}" != "1" ] && _flag="${TOUCH_RESULT}"
	find "${ROOTDIR}" \( -type d -o -type f \) -exec touch ${_flag} '{}' '+'
fi

exit 0
