#!/bin/sh
source ./config.sh
source ./_build_vars.sh
source ./_build_dirs.sh

[ -d bzip2-1.0.6.dy ] && exit 0

tar -zxf "${EXTDIR}"/bzip2-1.0.6.tar.gz || exit 1
mv bzip2-1.0.6 bzip2-1.0.6.dy
cd bzip2-1.0.6.dy
make -f Makefile-libbz2_so CC=${TARGET}-gcc CFLAGS=-fPIC || exit 1
cp -f libbz2.so.1.0.6 "${ROOTDIR}"/lib/
ln -sf libbz2.so.1.0.6 "${ROOTDIR}"/lib/libbz2.so.1.0
ln -sf libbz2.so.1.0.6 "${ROOTDIR}"/lib/libbz2.so
cp -f bzlib.h "${ROOTDIR}"/include/
cd ..
