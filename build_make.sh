#!/bin/sh

source ./config.sh
source ./_build_vars.sh
source ./_build_dirs.sh

[ -d make-3.81 ] && exit 0

[ "${USRDIR}" == "/" ] && export USRDIR=""

tar -jxf "${PKGDIR}"/make-3.81.tar.bz2 || exit 1
cd make-3.81
./configure --host=${TARGET} --prefix="${USRDIR}" --disable-nls
make || exit 1
make DESTDIR="${ROOTDIR}" install || exit 1
cd ..
