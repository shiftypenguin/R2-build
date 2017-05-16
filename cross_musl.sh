#!/bin/sh

source ./config.sh
source ./_cross_vars.sh
source ./_cross_dirs.sh

[ -d musl-1.1.4 ] && exit 0

[ -n "${ALL_STATIC}" ] && _static="--enable-static --disable-shared"
[ -z "${_static}" ] && _static="--disable-static"

tar -zxf "${PKGDIR}"/musl-1.1.4.tar.gz || exit 1
cd musl-1.1.4
# this patch is needed if we cross compile exts that perform authentication
patch -Np1 -i "${PKGDIR}"/patches/musl-1.1.4-crypt-sk1024.patch
patch -Np1 -i "${PKGDIR}"/patches/musl-1.1.4-ldpath-norpath.patch
patch -Np1 -i "${PKGDIR}"/patches/musl-1.1.4-syslog-year-tz.patch
[ "${USRDIR}" == "/" ] && patch -Np1 -i "${PKGDIR}"/patches/musl-1.1.4-nousr.patch
CROSS_COMPILE="${TARGET}-" ./configure --target=${TARGET} --prefix="${CROSSDIR}/${TARGET}/" --syslibdir="${CROSSDIR}/lib/" \
	--disable-gcc-wrapper ${_static}
make || exit 1
make install || exit 1
cd ..
