#!/bin/sh

source ./config.sh
source ./_build_vars.sh
source ./_build_dirs.sh

[ -d binutils-2.17.50.0.17 ] && exit 0

[ "${USRDIR}" == "/" ] && export USRDIR=""

tar -jxf "${PKGDIR}"/binutils-2.17.50.0.17.tar.bz2 || exit 1
cd binutils-2.17.50.0.17 || exit 1
sh "${PKGDIR}"/scripts/libibertyfix.sh libiberty
patch -Np1 -i "${PKGDIR}"/patches/binutils-2.17.50.0.17-1.patch
patch -Np1 -i "${PKGDIR}"/patches/binutils-2.17.50.0.17-musl-sldl.patch
./configure --host=${TARGET} --build=${BUILD} --target=${TARGET} --prefix="${USRDIR}" --libdir="${USRDIR}/lib" --disable-werror --disable-nls CFLAGS=-D_LARGEFILE64_SOURCE
make tooldir="${USRDIR}" || exit 1
make tooldir="${USRDIR}" DESTDIR="${ROOTDIR}" install || exit 1
cd ..
