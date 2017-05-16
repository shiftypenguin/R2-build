#!/bin/sh

source ./config.sh
source ./_build_vars.sh
source ./_build_dirs.sh

[ -d linux-3.2.32 ] && exit 0

case "${PARCH}" in
	i?86) ARCH=i386 ;;
	x86_64) ARCH=x86_64 ;;
	*) exit 2 ;;
esac

tar -jxf "${PKGDIR}"/linux-3.2.32.tar.bz2 || exit 1
cd linux-3.2.32
patch -Np1 -i "${PKGDIR}"/patches/linux-noperl-capflags.patch
patch -Np1 -i "${PKGDIR}"/patches/linux-noperl-headers.patch
patch -Np1 -i "${PKGDIR}"/patches/linux-noperl-timeconst.patch
patch -Np1 -i "${PKGDIR}"/patches/linux-3.2.12-disable-build-id.patch
patch -Np1 -i "${PKGDIR}"/patches/linux-3.2.12-disable-symvers-2.patch
patch -Np1 -i "${PKGDIR}"/patches/linux-3.2.32-proc-sys-rootonly.patch
patch -Np1 -i "${PKGDIR}"/patches/linux-3.2.32-user-sees-own-procs-2.patch
patch -Np1 -i "${PKGDIR}"/patches/linux-3.2.32-xt_owner-groups.patch
patch -Np1 -i "${PKGDIR}"/patches/linux-3.2.32-CVE-2013-2094.patch
make distclean

make ARCH=${ARCH} CROSS_COMPILE="${TARGET}-" HOSTCFLAGS="-D_GNU_SOURCE" INSTALL_HDR_PATH=dest headers_install || exit 1
find dest/include \( -name .install -o -name ..install.cmd \) -delete
cp -rv dest/include/* "${ROOTDIR}${USRDIR}/include/"

export TZ=UTC

if [ -n "${LINUX_CONFIG}" ]; then
	if [ -f "${PKGDIR}/${LINUX_CONFIG}" ]; then
		cp -a "${PKGDIR}/${LINUX_CONFIG}" .config
	else
		echo "Specified Linux kernel config file ${PKGDIR}/${LINUX_CONFIG} not found."
		exit 2
	fi
else	
case "${ARCH}" in
	i386) cp -a "${PKGDIR}"/linux.i386.config .config ;;
	x86_64) cp -a "${PKGDIR}"/linux.x86_64.config .config ;;
esac
fi

make ARCH=${ARCH} CROSS_COMPILE="${TARGET}-" || exit 1

mkdir -p "${ROOTDIR}/boot"
cp -a .config "${ROOTDIR}/boot/linux.conf"
case ${ARCH} in
	i386|x86_64)
		cp -a arch/x86/boot/bzImage "${ROOTDIR}/boot/linux"
	;;
esac
unset TZ

cd ..
