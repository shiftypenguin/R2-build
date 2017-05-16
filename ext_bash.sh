#!/bin/sh
source ./config.sh
source ./_build_vars.sh
source ./_build_dirs.sh

[ -d bash-3.0.16 ] && exit 0

tar -zxf "${EXTDIR}"/bash-3.0.16.tar.gz || exit 1
cd bash-3.0.16
[ -n "${ALL_STATIC}" ] && _static="--enable-static-link"
./configure --host=${TARGET} --prefix= ${_static} --disable-nls --disable-rpath \
	--without-bash-malloc --without-installed-readline --without-included-gettext || exit 1
make || exit 1
rm -f "${ROOTDIR}"/bin/bash
cp -a bash "${ROOTDIR}"/bin/ || exit 1
cp -a "${EXTDIR}"/scripts/inputrc "${ROOTDIR}"/etc/ || exit 1
cd ..
