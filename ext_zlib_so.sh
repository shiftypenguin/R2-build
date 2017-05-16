#!/bin/sh
source ./config.sh
source ./_build_vars.sh
source ./_build_dirs.sh

[ -d zlib-1.2.5.dy ] && exit 0

tar -jxf "${EXTDIR}"/zlib-1.2.5.tar.bz2 || exit 1
mv zlib-1.2.5 zlib-1.2.5.dy
cd zlib-1.2.5.dy
patch -Np1 -i "${EXTDIR}"/patches/zlib-1.2.5-disable-symvers.patch
CC=${TARGET}-gcc AR=${TARGET}-ar RANLIB=${TARGET}-ranlib ./configure --prefix= || exit 1
sed -i 's,mktemp -u,mktemp,g' Makefile
make || exit 1
make DESTDIR="${ROOTDIR}" install || exit 1
cd ..
