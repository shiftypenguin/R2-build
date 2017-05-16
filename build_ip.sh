#!/bin/sh

source ./config.sh
source ./_build_vars.sh
source ./_build_dirs.sh

[ -d iproute2-2.6.38 ] && exit 0

tar -jxf "${PKGDIR}"/iproute2-2.6.38.tar.bz2 || exit 1
cd iproute2-2.6.38
patch -Np1 -i "${PKGDIR}"/patches/iproute2-2.6.38-musl-compat.patch
patch -Np1 -i "${PKGDIR}"/patches/iproute2-2.6.38-ss-disable-ssfilter.patch
make SUBDIRS="lib ip" TARGETS=ip DESTDIR= DOCDIR=/usr/share/doc/iproute2 MANDIR=/usr/share/man CC=${TARGET}-gcc AR=${TARGET}-ar || exit 1
make SUBDIRS=misc TARGETS=ss DESTDIR= DOCDIR=/usr/share/doc/iproute2 MANDIR=/usr/share/man CC=${TARGET}-gcc AR=${TARGET}-ar || exit 1
cp -a ip/ip "${ROOTDIR}/bin/ip"
cp -a misc/ss "${ROOTDIR}/bin/ss"
cp -a etc/iproute2 "${ROOTDIR}/etc"
cd ..
