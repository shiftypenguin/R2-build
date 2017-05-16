#!/bin/sh
source ./config.sh
source ./_build_vars.sh
source ./_build_dirs.sh

[ -d zlib-1.2.5.st ] && exit 0

tar -jxf "${EXTDIR}"/zlib-1.2.5.tar.bz2 || exit 1
mv zlib-1.2.5 zlib-1.2.5.st
cd zlib-1.2.5.st
patch -Np1 -i "${EXTDIR}"/patches/zlib-1.2.5-disable-symvers.patch
CC=${TARGET}-gcc AR=${TARGET}-ar RANLIB=${TARGET}-ranlib ./configure --prefix= --static || exit 1
sed -i 's,mktemp -u,mktemp,g' Makefile
make || exit 1
${TARGET}-ranlib libz.a
install -m644 libz.a "${ROOTDIR}"/lib/
install -m644 zlib.h zconf.h "${ROOTDIR}"/include/
cd ..
