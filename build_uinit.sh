#!/bin/sh

source ./config.sh
source ./_build_vars.sh
source ./_build_dirs.sh

[ -d uinit ] && exit 0

tar -zxf "${PKGDIR}"/uinit.tar.gz || exit 1
cd uinit
make CC=${TARGET}-gcc || exit 1
make DESTDIR="${ROOTDIR}" install
cd ..
