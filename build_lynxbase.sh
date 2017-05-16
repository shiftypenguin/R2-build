#!/bin/sh

source ./config.sh
source ./_build_vars.sh
source ./_build_dirs.sh

[ -d lynxbase ] && exit 0

cp -a "${PKGDIR}"/lynxbase .
cd lynxbase

make CC=${TARGET}-gcc || exit 1
make install PREFIX="${ROOTDIR}" || exit 1
ln -sf fork "${ROOTDIR}"/bin/lh || exit 1
tar -zxf shred.tar.gz
cd shred
make CC=${TARGET}-gcc || exit 1
cp -a shred "${ROOTDIR}/bin/shred"
cd ..
cd ..
