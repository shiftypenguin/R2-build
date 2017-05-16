#!/bin/sh

source ./config.sh
source ./_build_vars.sh
source ./_build_dirs.sh

[ -d musl-1.1.4 ] && exit 0

[ -n "${ALL_STATIC}" ] && _static="--enable-static --disable-shared"
[ -z "${_static}" ] && _static=

tar -zxf "${PKGDIR}"/musl-1.1.4.tar.gz || exit 1
cd musl-1.1.4
patch -Np1 -i "${PKGDIR}"/patches/musl-1.1.4-crypt-sk1024.patch
patch -Np1 -i "${PKGDIR}"/patches/musl-1.1.4-ldpath-norpath.patch
patch -Np1 -i "${PKGDIR}"/patches/musl-1.1.4-syslog-year-tz.patch
patch -Np1 -i "${PKGDIR}"/patches/musl_inet_pton_overflow_fix.diff
[ "${USRDIR}" == "/" ] && patch -Np1 -i "${PKGDIR}"/patches/musl-1.1.4-nousr.patch
CROSS_COMPILE="${TARGET}-" ./configure --target=${TARGET} --prefix="${USRDIR}" --disable-gcc-wrapper ${_static}
make || exit 1
make DESTDIR="${ROOTDIR}" install || exit 1
cd ..
