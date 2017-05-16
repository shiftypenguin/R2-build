#!/bin/sh

source ./config.sh
source ./_cross_vars.sh
source ./_cross_dirs.sh

[ -d gcc-4.2.1 ] && exit 0

tar -jxf "${PKGDIR}"/gcc-core-4.2.1.tar.bz2 || exit 1
cd gcc-4.2.1 || exit 1
patch -Np1 -i "${PKGDIR}"/patches/gcc-4.2.1-1.patch
patch -Np1 -i "${PKGDIR}"/patches/gcc-4.2.1-lib32-sldl.patch
patch -Np1 -i "${PKGDIR}"/patches/gcc-4.2.1-nofixinc.patch
[ -n "${ALL_STATIC}" ] && patch -Np1 -i "${PKGDIR}"/patches/gcc-4.2.1-static-libc.patch
mkdir ../gcc-build || exit 1
cd ../gcc-build
../gcc-4.2.1/configure --target=${TARGET} --enable-languages=c --without-headers --with-newlib \
	--enable-multilib=no --disable-threads --disable-shared --disable-nls \
	--disable-libssp --disable-libquadmath --disable-decimal-float \
	--disable-libmudflap --disable-libgomp \
	--prefix="${CROSSDIR}" ${GCC_EXTRA}
make || exit 1
make install || exit 1
rm "${CROSSDIR}"/lib/gcc/${TARGET}/4.2.1/include/limits.h
# echo '#include <unistd.h>' >"${CROSSDIR}"/lib/gcc/${TARGET}/3.4.4/include/stddef.h
cd ..
