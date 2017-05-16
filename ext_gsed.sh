#!/bin/sh
source ./config.sh
source ./_build_vars.sh
source ./_build_dirs.sh

[ -d sed-4.1.5 ] && exit 0

tar -zxf "${EXTDIR}"/sed-4.1.5.tar.gz || exit 1
cd sed-4.1.5
sed -i 's@getline@my&@g' lib/getline.c
sed -i 's@-lcP@@g' configure
./configure --host=${TARGET} --prefix= --disable-nls || exit 1
make || exit 1
rm -f "${ROOTDIR}"/bin/sed
cp -a sed/sed "${ROOTDIR}"/bin/ || exit 1
cd ..
