#!/bin/sh
source ./config.sh
source ./_build_vars.sh
source ./_build_dirs.sh

[ -d hexedit ] && exit 0

tar -zxf "${EXTDIR}"/hexedit-1.2.12.src.tgz || exit 1
cd hexedit
./configure --host=${TARGET} --prefix= CFLAGS=-I"${ROOTDIR}"/include LDFLAGS=-L"${ROOTDIR}"/lib || exit 1
make || exit 1
cp -a hexedit "${ROOTDIR}"/bin/ || exit 1
mkdir -p "${ROOTDIR}"/man/man1 || exit 1
cp -a hexedit.1 "${ROOTDIR}"/man/man1 || exit 1
cd ..
