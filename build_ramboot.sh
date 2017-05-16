#!/bin/sh

source ./config.sh
source ./_build_vars.sh
source ./_build_dirs.sh

mkdir ramboot || exit 1
cd ramboot

cp -ai "${PKGDIR}"/scripts/raminit init
cp -ai "${PKGDIR}"/scripts/raminit_altinit altinit

mkdir bin dev etc lib proc sbin sys
mkdir -m1777 tmp
ln -s / usr

if [ -z "${ALL_STATIC}" ]; then
	cp -a "${ROOTDIR}"/lib/libc.so "${ROOTDIR}"/lib/sldl lib
fi
cp -a "${ROOTDIR}"/bin/busybox "${ROOTDIR}"/bin/execvp bin
cp -a "${ROOTDIR}"/sbin/smdev .
ln -s busybox bin/sh

find . | cpio -o -H newc | gzip -9nc >"${ROOTDIR}"/boot/ramboot.gz
touch "${ROOTDIR}"/.ramlinux

cd ..
