#!/bin/sh

source ./config.sh
source ./_build_vars.sh
source ./_build_dirs.sh

[ -d linux-3.2.32 ] && exit 0

case "${PARCH}" in
	i?86) ARCH=i386 ;;
	x86_64) ARCH=x86_64 ;;
	arm*) ARCH=arm ;;
	mips*) ARCH=mips ;;
	powerpc*) ARCH=powerpc ;;
	*) exit 2 ;;
esac

tar -jxf "${PKGDIR}"/linux-3.2.32.tar.bz2 || exit 1
cd linux-3.2.32
patch -Np1 -i "${PKGDIR}"/patches/linux-noperl-capflags.patch
patch -Np1 -i "${PKGDIR}"/patches/linux-noperl-headers.patch
patch -Np1 -i "${PKGDIR}"/patches/linux-3.2.12-disable-build-id.patch
patch -Np1 -i "${PKGDIR}"/patches/linux-3.2.12-disable-symvers-2.patch
patch -Np1 -i "${PKGDIR}"/patches/linux-3.2.32-proc-sys-rootonly.patch
patch -Np1 -i "${PKGDIR}"/patches/linux-3.2.32-user-sees-own-procs-2.patch
make distclean

make ARCH=${ARCH} CROSS_COMPILE="${TARGET}-" HOSTCFLAGS="-D_GNU_SOURCE" INSTALL_HDR_PATH=dest headers_install || exit 1
find dest/include \( -name .install -o -name ..install.cmd \) -delete
cp -rv dest/include/* "${ROOTDIR}${USRDIR}/include/"
cd ..
