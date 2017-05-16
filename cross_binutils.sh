#!/bin/sh

source ./config.sh
source ./_cross_vars.sh
source ./_cross_dirs.sh

[ -d binutils-2.17.50.0.17 ] && exit 0

tar -jxf "${PKGDIR}"/binutils-2.17.50.0.17.tar.bz2 || exit 1
cd binutils-2.17.50.0.17 || exit 1
patch -Np1 -i "${PKGDIR}"/patches/binutils-2.17.50.0.17-1.patch
patch -Np1 -i "${PKGDIR}"/patches/binutils-2.17.50.0.17-musl-sldl.patch
./configure --target=${TARGET} --prefix="${CROSSDIR}" --disable-werror --disable-nls
make || exit 1
make install || exit 1
cd ..
