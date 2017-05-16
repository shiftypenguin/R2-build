#!/bin/sh

# Do various embedded optimizations and install embedded commands from there

source ./config.sh
source ./_build_vars.sh
source ./_build_dirs.sh

[ -z "${EMBEDDED}" ] && exit 0

swd "${ROOTDIR}" patch -Np0 -i "${PKGDIR}"/patches/uinit_rc_boot_norw.diff
cp -a "${PKGDIR}"/scripts/ro "${PKGDIR}"/scripts/rw "${ROOTDIR}/sbin"
cp -a "${PKGDIR}"/scripts/altinit_dbgshell "${ROOTDIR}"/etc/init/altinit
