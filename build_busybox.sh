#!/bin/sh

source ./config.sh
source ./_build_vars.sh
source ./_build_dirs.sh

[ -d busybox-1.20.1 ] && exit 0

tar -jxf "${PKGDIR}"/busybox-1.20.1.tar.bz2 || exit 1
cd busybox-1.20.1
patch -Np1 -i "${PKGDIR}"/patches/busybox-1.20.1-2.patch
patch -Np1 -i "${PKGDIR}"/patches/busybox-1.20.1-ether-local.patch
patch -Np1 -i "${PKGDIR}"/patches/busybox-1.20.1-make_unicode_printable.patch
patch -Np1 -i "${PKGDIR}"/patches/busybox-1.20.1-sysklogd-year.patch
patch -Np1 -i "${PKGDIR}"/patches/busybox-1.20.1-mke2fs.patch
patch -Np1 -i "${PKGDIR}"/patches/busybox-1.20.1-ntpd-fix.patch
patch -Np1 -i "${PKGDIR}"/patches/busybox-1.20.1-ping4-error.patch
patch -Np1 -i "${PKGDIR}"/patches/busybox-1.20.1-ping-flood.patch
patch -Np1 -i "${PKGDIR}"/patches/busybox-1.20.1-acpid-lid-switch.patch
if [ -n "${BUSYBOX_CONFIG}" ]; then
	if [ -f "${PKGDIR}/${BUSYBOX_CONFIG}" ]; then
		cp -a "${PKGDIR}/${BUSYBOX_CONFIG}" .config
	else
		echo "Specified busybox config file ${PKGDIR}/${BUSYBOX_CONFIG} not found."
		exit 2
	fi
else
	cp -a "${PKGDIR}"/busybox.config .config
fi
[ "${USRDIR}" == "/" ] && sed -i 's@.*CONFIG_INSTALL_NO_USR\ is.*@CONFIG_INSTALL_NO_USR=y@' .config
[ -n "${EMBEDDED}" ] && sed -i 's@CONFIG_LOCALE_SUPPORT=y@# CONFIG_LOCALE_SUPPORT is not set@g' .config
make CROSS_COMPILE="${TARGET}-" HOSTCFLAGS="-D_GNU_SOURCE" busybox || exit 1
make busybox.links || exit 1
sh applets/install.sh "${ROOTDIR}" --symlinks
# Why busybox puts killall5 in bin?
ln -sf ../bin/busybox "${ROOTDIR}"/sbin/killall5
rm -f "${ROOTDIR}"/bin/killall5
mkdir -p "${ROOTDIR}/etc" || exit 1
cp -a "${PKGDIR}"/busybox_mdev.config "${ROOTDIR}/etc/mdev.conf"
mkdir -p "${ROOTDIR}/etc" || exit 1
cp -a "${PKGDIR}"/scripts/busybox_udhcpc.script "${ROOTDIR}/etc/udhcpc.script"
mkdir -p "${ROOTDIR}"/etc/acpi/PWRF
cp -a "${PKGDIR}"/scripts/acpi_pwrf.sh "${ROOTDIR}/etc/acpi/PWRF/00000080"
cd ..
