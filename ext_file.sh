#!/bin/sh
source ./config.sh
source ./_build_vars.sh
source ./_build_dirs.sh

tar -zxf "${EXTDIR}"/file-5.10.tar.gz || exit 1
cd file-5.10
./configure --host=${TARGET} --prefix= --disable-shared || exit 1
make || exit 1
make DESTDIR="${ROOTDIR}" install
cd ..
