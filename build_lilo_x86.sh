#!/bin/sh

source ./config.sh
source ./_build_vars.sh
source ./_build_dirs.sh

[ -d lilo-22.8 ] && exit 0

tar -zxf "${PKGDIR}"/lilo-22.8.tar.gz || exit 1
cd lilo-22.8
patch -Np1 -i "${PKGDIR}"/patches/lilo-22.8-musl.patch
echo >checkit
make lilo CC=${TARGET}-gcc || exit 1
export _OPATH="${PATH}"
export PATH="${CROSSDIR}/${TARGET}/bin:${PATH}"
make ROOT="${ROOTDIR}" install
export PATH="${_OPATH}"
if [ "${USRDIR}" == "/" ]; then
	cp -a "${ROOTDIR}"/usr/* "${ROOTDIR}"
	fork rm -r "${ROOTDIR}"/usr
elif [ "${USRDIR}" != "/usr" ]; then
	cp -a "${ROOTDIR}"/usr/* "${ROOTDIR}${USRDIR}"
	fork rm -r "${ROOTDIR}"/usr
fi
cd ..
