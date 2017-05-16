#!/bin/sh
# This script will build and replace current cross compiler will fully functional one

source ./config.sh
source ./_cross_vars.sh
source ./_cross_dirs.sh

[ -d gcc-4.2.1.st ] && exit 0

[ -d gcc-4.2.1 ] && mv gcc-4.2.1 gcc-4.2.1.st
[ -d gcc-build ] && mv gcc-build gcc-build.st
tar -jxf "${PKGDIR}"/gcc-core-4.2.1.tar.bz2 || exit 1
cd gcc-4.2.1 || exit 1
sh "${PKGDIR}"/scripts/libibertyfix.sh libiberty
patch -Np1 -i "${PKGDIR}"/patches/gcc-4.2.1-1.patch
patch -Np1 -i "${PKGDIR}"/patches/gcc-4.2.1-lib32-sldl.patch
patch -Np1 -i "${PKGDIR}"/patches/gcc-4.2.1-nofixinc.patch
[ -n "${ALL_STATIC}" ] && patch -Np1 -i "${PKGDIR}"/patches/gcc-4.2.1-static-libc.patch
mkdir ../gcc-build || exit 1
cd ../gcc-build
../gcc-4.2.1/configure --target=${TARGET} --enable-languages=c --without-headers \
	--with-newlib --disable-multilib --enable-multilib=no --disable-shared --disable-nls \
	--disable-libssp --disable-libquadmath --disable-libmudflap \
	--enable-c99 --enable-long-long \
	--prefix="${CROSSDIR}" ${GCC_EXTRA}
make || exit 1
make install || exit 1
rm "${CROSSDIR}"/lib/gcc/${TARGET}/4.2.1/include/limits.h
# echo '#include <unistd.h>' >"${CROSSDIR}"/lib/gcc/${TARGET}/3.4.4/include/stddef.h
cd ..
