#!/bin/sh
source ./config.sh
source ./_build_vars.sh
source ./_build_dirs.sh

[ -d iptables-1.4.12.1 ] && exit 0

tar -jxf "${EXTDIR}"/iptables-1.4.12.1.tar.bz2 || exit 1
cd iptables-1.4.12.1
patch -Np1 -i "${EXTDIR}"/patches/iptables-1.4.14-musl-fixes.patch
patch -Np1 -i "${EXTDIR}"/patches/iptables-1.4.12.1-xt_owner-groups.patch
_WDIR="${PWD}"
tar -jxf "${EXTDIR}"/gnu-getopt-0.0.1.tar.bz2 || exit 1
cd gnu-getopt-0.0.1
make CC=${TARGET}-gcc || exit 1
cd ..
sed -i '/linux\/tcp\.h/d' include/linux/netfilter/xt_osf.h
./configure --host=${TARGET} --prefix= --disable-shared \
	CFLAGS=-include\ "${CROSSDIR}"/"${TARGET}"/include/linux/types.h\ -Dgetopt=gnu_getopt\ -Dgetopt_long=gnu_getopt_long\ -Dgetopt_long_only=gnu_getopt_long_only \
	LDFLAGS="${_WDIR}"/gnu-getopt-0.0.1/libgnu_getopt.a
make || exit 1
make DESTDIR="${ROOTDIR}" install || exit 1

mkdir -p -m750 "${ROOTDIR}"/etc/iptables
cat > "${ROOTDIR}"/etc/iptables/iprules << EOF
*nat
:PREROUTING ACCEPT [0:0]
:INPUT ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
:POSTROUTING ACCEPT [0:0]
COMMIT
*mangle
:PREROUTING ACCEPT [0:0]
:INPUT ACCEPT [0:0]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
:POSTROUTING ACCEPT [0:0]
COMMIT
*filter
:INPUT ACCEPT [0:0]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
-A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
-A INPUT -i lo -j ACCEPT
-A INPUT -j DROP
-A FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
-A FORWARD -j DROP
-A OUTPUT -m owner --uid-owner 0 -j ACCEPT
-A OUTPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
-A OUTPUT -j DROP
COMMIT
EOF
cat > "${ROOTDIR}"/etc/iptables/ip6rules << EOF
*mangle
:PREROUTING ACCEPT [0:0]
:INPUT ACCEPT [0:0]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
:POSTROUTING ACCEPT [0:0]
COMMIT
*filter
:INPUT ACCEPT [0:0]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
-A INPUT -p icmpv6 -j ACCEPT
-A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
-A INPUT -i lo -j ACCEPT
-A INPUT -j DROP
-A FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
-A FORWARD -j DROP
-A OUTPUT -m owner --uid-owner 0 -j ACCEPT
-A OUTPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
-A OUTPUT -j DROP
COMMIT
EOF

cp -a "${EXTDIR}"/scripts/iptsave "${EXTDIR}"/scripts/iptrestore "${ROOTDIR}"/sbin
cd ..
