#!/bin/sh

source ./config.sh
source ./_build_vars.sh
source ./_build_dirs.sh

[ -d libressl-2.3.0 ] && exit 0

_shared="--disable-shared"
tar -zxf "${EXTDIR}"/libressl-2.3.0.tar.gz || exit 1
cd libressl-2.3.0
[ -z "${ALL_STATIC}" ] && _shared="--enable-shared"
./configure --host=${TARGET} --prefix= --disable-asm ${_shared}
# We don't need netcat, we have our own
rm -fr apps/nc; mkdir -p apps/nc
printf 'all:\ninstall:\n' >apps/nc/Makefile
make || exit 1
make DESTDIR="${ROOTDIR}" install
cd ..
