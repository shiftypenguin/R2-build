#!/bin/sh
source ./config.sh
source ./_build_vars.sh
source ./_build_dirs.sh

[ -d libpcap-1.2.1 ] && exit 0
[ -d tcpdump-4.4.0 ] && exit 0

tar -zxf "${EXTDIR}"/libpcap-1.2.1.tar.gz || exit 1
cd libpcap-1.2.1
./configure --host=${TARGET} --prefix= --disable-shared --with-pcap=linux ac_cv_type_u_int64_t=yes CFLAGS="-D_GNU_SOURCE -D_BSD_SOURCE -DIPPROTO_HOPOPTS=0" || exit 1
make || exit 1
cd ..
tar -zxf "${EXTDIR}"/tcpdump-4.4.0.tar.gz || exit 1
cd tcpdump-4.4.0
# Why you so bad at cross compiling??
./configure --host=${TARGET} --prefix= --enable-ipv6 --without-crypto td_cv_buggygetaddrinfo=no ac_cv_linux_vers=3 CFLAGS="-D_GNU_SOURCE -D_BSD_SOURCE" LDFLAGS=-L"${ROOTDIR}"/lib LIBS=-lz || exit 1
make || exit 1
cp -a tcpdump "${ROOTDIR}"/sbin/ || exit 1
mkdir -p "${ROOTDIR}"/man/man1 || exit 1
cp -a tcpdump.1 "${ROOTDIR}"/man/man1 || exit 1
cd ..
