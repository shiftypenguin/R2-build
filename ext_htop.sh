#!/bin/sh
source ./config.sh
source ./_build_vars.sh
source ./_build_dirs.sh

[ -d htop-1.0.1 ] && exit 0

tar -zxf "${EXTDIR}"/htop-1.0.1.tar.gz || exit 1
cd htop-1.0.1
patch -Np1 -i "${EXTDIR}"/patches/htop-1.0.1-elim-dotconf.patch
./configure --host=${TARGET} --prefix= --enable-taskstats --disable-unicode CFLAGS=-I"${ROOTDIR}"/include LDFLAGS=-L"${ROOTDIR}"/lib || exit 1
sh -c '> scripts/MakeHeader.py'
make || exit 1
cp -a htop "${ROOTDIR}"/bin/ || exit 1
cp -a "${EXTDIR}"/scripts/htoprc "${ROOTDIR}"/etc/ || exit 1
mkdir -p "${ROOTDIR}"/man/man1 || exit 1
cp -a htop.1 "${ROOTDIR}"/man/man1 || exit 1
cd ..
