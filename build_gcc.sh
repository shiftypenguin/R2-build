#!/bin/sh

source ./config.sh
source ./_build_vars.sh
source ./_build_dirs.sh

[ -d gcc-4.2.1 ] && exit 0

[ "${USRDIR}" == "/" ] && export USRDIR=""

tar -jxf "${PKGDIR}"/gcc-core-4.2.1.tar.bz2 || exit 1
cd gcc-4.2.1
sh "${PKGDIR}"/scripts/libibertyfix.sh libiberty
patch -Np1 -i "${PKGDIR}"/patches/gcc-4.2.1-1.patch
patch -Np1 -i "${PKGDIR}"/patches/gcc-4.2.1-lib32-sldl.patch
patch -Np1 -i "${PKGDIR}"/patches/gcc-4.2.1-nofixinc.patch
[ -n "${ALL_STATIC}" ] && patch -Np1 -i "${PKGDIR}"/patches/gcc-4.2.1-static-libc.patch
sed -i 's/install_to_$(INSTALL_DEST) //' libiberty/Makefile.in
sed -i -e '/syslimits.h/d' gcc/limitx.h
mkdir ../gcc-build || exit 1
cd ../gcc-build
../gcc-4.2.1/configure --build=${BUILD} --host=${TARGET} --target=${TARGET} --prefix="${USRDIR}" --libexecdir="${USRDIR}/lib" \
	--with-newlib --enable-c99 --disable-nls --disable-shared --disable-multilib \
	--disable-mudflap --disable-libmudflap --disable-libssp ${GCC_EXTRA}
make configure-host || exit 1
sed -i -e 's@--build=[^\ ]*\ @@g' gcc/configargs.h
make || exit 1
make DESTDIR="${ROOTDIR}" install || exit 1
for obj in $(find "${ROOTDIR}${USRDIR}/lib" -mindepth 1 -maxdepth 1 -type f -iname \*crt\*.o); do
	ln -s "${USRDIR}/lib/$(basename ${obj})" "${ROOTDIR}${USRDIR}/lib/gcc/${TARGET}/4.2.1"
done
ln -s /bin/ld "${ROOTDIR}${USRDIR}/lib/gcc/${TARGET}/4.2.1"
rm -fr "${ROOTDIR}${USRDIR}"/lib/gcc/${TARGET}/4.2.1/install-tools "${ROOTDIR}${USRDIR}"/bin/gccbug
rm "${ROOTDIR}${USRDIR}"/lib/gcc/${TARGET}/4.2.1/include/limits.h
cd ..
