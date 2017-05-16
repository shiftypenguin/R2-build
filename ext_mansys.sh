#!/bin/sh
# This will install complete manual page system, based on BSD mdocml package and man script
# Yes, I do know that mandoc now have it's own man(1), but it requires sqlite.

source ./config.sh
source ./_build_vars.sh
source ./_build_dirs.sh

[ -d man-pages-3.54 ] && exit 0
[ -d mdocml-1.13.2 ] && exit 0

[ "${USRDIR}" == "/" ] && export USRDIR=""

tar -zxf "${EXTDIR}"/man-pages-3.54.tar.gz || exit 1
cd man-pages-3.54
make DESTDIR="${ROOTDIR}" prefix="${USRDIR}" install
cd ..

tar -zxf "${EXTDIR}"/mdocml-1.13.2.tar.gz || exit 1
cd mdocml-1.13.2

# For musl, define everything it supports
# Also set our prefix and os name
# Without all those HAVE_* you will end up with ascii only mandoc.
# I put here only those that I remember that musl support them

cat > configure.local << EOF
PREFIX=
OSNAME=R2
HAVE_WCHAR=1
HAVE_FGETLN=1
HAVE_MMAP=1
HAVE_STRCASESTR=1
HAVE_STRLCAT=1
HAVE_STRLCPY=1
HAVE_STRPTIME=1
HAVE_STRSEP=1
BUILD_DB=0
EOF

# Without any arguments.
./configure || exit 1
make CC=${TARGET}-gcc || exit 1
make DESTDIR="${ROOTDIR}" install || exit 1
cp -a "${EXTDIR}"/scripts/man "${ROOTDIR}"/bin/ || exit 1
# Make no troubles for strip...
chmod 644 "${ROOTDIR}"/lib/mandoc/libmandoc.a
chmod 755 "${ROOTDIR}"/bin/mandoc "${ROOTDIR}"/bin/demandoc
cd ..
