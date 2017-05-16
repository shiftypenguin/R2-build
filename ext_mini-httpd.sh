#!/bin/sh
source ./config.sh
source ./_build_vars.sh
source ./_build_dirs.sh

[ -d mini_httpd-1.19 ] && exit 0

tar -zxf "${EXTDIR}"/mini_httpd-1.19.tar.gz || exit 1
cd mini_httpd-1.19
patch -Np1 -i "${EXTDIR}"/patches/mini_httpd-1.19-ouropts_nosyslog_xrealip.patch
make CC=${TARGET}-gcc mini_httpd || exit 1
cp -a mini_httpd "${ROOTDIR}"/sbin/ || exit 1
cd ..
