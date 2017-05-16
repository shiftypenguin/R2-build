#!/bin/sh

source ./config.sh
source ./_build_vars.sh
source ./_build_dirs.sh

[ -d tinc-1.0.16 ] && exit 0

tar -zxf "${EXTDIR}"/tinc-1.0.16.tar.gz || exit 1
cd tinc-1.0.16
patch -Np1 -i "${EXTDIR}"/patches/tinc-1.0.16-dont-flood-logs.patch
patch -Np1 -i "${EXTDIR}"/patches/tinc-1.0.16-drop-big-packet.patch
patch -Np1 -i "${EXTDIR}"/patches/tinc-1.0.16-ipv6-doublecolon.patch
./configure --host=${TARGET} --prefix= --disable-lzo --enable-jumbograms CFLAGS=-I"${ROOTDIR}/include" LDFLAGS=-L"${ROOTDIR}"/lib LIBS=-lz
# Multiple header definitions conflict - fix it
sed -i 's@^CFLAGS = .*@& -D_LINUX_IF_ETHER_H@' src/Makefile
make || exit 1
if [ -n "${EMBEDDED}" ]; then
	cp -a src/tinc "${ROOTDIR}"/sbin/ || exit 1
else
	make DESTDIR="${ROOTDIR}" install || exit 1
fi
mkdir -m750 "${ROOTDIR}"/etc/tinc
cd ..
