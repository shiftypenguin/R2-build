#!/bin/sh

source ./config.sh
source ./_build_vars.sh
source ./_build_dirs.sh

[ -d memtest86+-5.0.1 ] && exit 0

tar -zxf "${EXTDIR}"/memtest86+-5.01.tar.gz || exit 1
cd memtest86+-5.01
# It has precompiled stuff. Get rid of it
cat "${EXTDIR}"/memtest86+-5.01.tar.gz.bins | xargs rm
# Ugly fix maybe, but let it be
# See also http://www.openwall.com/lists/musl/2015/11/08/7
mkdir sys || exit 1
cp -a "${EXTDIR}"/memtest86+-5.01-sysio.h sys/io.h || exit 1
# Stupid gccists, you driven me to hiss when I patched intel
# videodriver loaded FULL with this sh*t
# Fortunately, I've done that with sed+sh+bc magic.
sed -i 's@0b10@2@g' init.c
# What?! Ah, quick upload to avail
sed -i '/scp /d' Makefile
# I hope it will build even with x86_64 compiler
# At least my local x86_64 gcc makes it
make CC="${TARGET}-gcc -I." || exit 1
mkdir -p "${ROOTDIR}"/boot || exit 1
cp -a memtest.bin "${ROOTDIR}"/boot/ || exit 1
printf '%s\n' 'image=/boot/memtest.bin' >>"${ROOTDIR}"/etc/lilo.conf
printf '\t%s\n' 'label=memtest86' >>"${ROOTDIR}"/etc/lilo.conf
cd ..
