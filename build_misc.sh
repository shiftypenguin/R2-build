#!/bin/sh

source ./config.sh
source ./_build_vars.sh
source ./_build_dirs.sh

${TARGET}-gcc ${CFLAGS} ${LDFLAGS} "${PKGDIR}"/prog/netcat.c -o "${ROOTDIR}/bin/nc"
