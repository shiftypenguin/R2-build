#!/bin/sh
source ./config.sh
source ./_build_vars.sh
source ./_build_dirs.sh

[ -d patch-2.5.9 ] && exit 0

tar -zxf "${EXTDIR}"/patch-2.5.9.tar.gz || exit 1
cd patch-2.5.9
./configure --host=${TARGET} --prefix= || exit 1
make || exit 1
rm -f "${ROOTDIR}"/bin/patch
cp -a patch "${ROOTDIR}"/bin/ || exit 1
cd ..
