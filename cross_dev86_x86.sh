#!/bin/sh

source ./config.sh
source ./_cross_vars.sh
source ./_cross_dirs.sh

[ -d dev86-0.16.18 ] && exit 0

tar -zxf "${PKGDIR}"/Dev86src-0.16.18.tar.gz || exit 1
cd dev86-0.16.18
patch -Np0 -i "${PKGDIR}"/patches/bin86-0.16.17-amd64-build.patch
touch as/version.h ld/version.h
sed -i '/include A_OUT_INCL/d' ld/bindef.h
make -C as || exit 1
make -C ld || exit 1
cp -f as/as86 ld/ld86 "${CROSSDIR}"/bin
cd ..
