#!/bin/sh

source ./config.sh
source ./_build_vars.sh
source ./_build_dirs.sh

[ -d e2fsprogs-1.41.14 ] && exit 0

[ "${USRDIR}" == "/" ] && export USRDIR=""

tar -zxf "${PKGDIR}"/e2fsprogs-1.41.14.tar.gz || exit 1
cd e2fsprogs-1.41.14
patch -Np1 -i "${PKGDIR}"/patches/e2fsprogs-nonx86.patch
patch -Np1 -i "${PKGDIR}"/patches/e2fsprogs-1.41.14-fixes.patch
./configure -C --host=${TARGET} --prefix="${USRDIR}" --with-root-prefix="${USRDIR}" --sbindir="${USRDIR}"/bin \
	--disable-nls --disable-tls
sed -i 's:sys/signal.h:signal.h:' misc/fsck.c
make || exit 1
make DESTDIR="${ROOTDIR}" install -k || exit 1
cd lib/uuid
make DESTDIR="${ROOTDIR}" install
chmod 644 "${ROOTDIR}${USRDIR}"/lib/libuuid.a
cd ../..
cd ..
