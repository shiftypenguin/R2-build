#!/bin/sh

source ./config.sh
source ./_build_vars.sh
source ./_build_dirs.sh

[ -d super-1.9.4 ] && exit 0

tar -zxf "${PKGDIR}"/super-1.9.4.tar.gz || exit 1
cd super-1.9.4
patch -Np1 -i "${PKGDIR}"/patches/super_fixdirs.diff
make CC=${TARGET}-gcc || exit 1
cp -a super "${ROOTDIR}/bin/super" || exit 1
mkdir -p "${ROOTDIR}/man/man8" "${ROOTDIR}/man/man5" || exit 1
cp -a super.8 "${ROOTDIR}/man/man8" || exit 1
cp -a super.conf.5 "${ROOTDIR}/man/man5" || exit 1
rm -f "${ROOTDIR}/bin/su"
ln -sf super "${ROOTDIR}/bin/su"
ln -sf super "${ROOTDIR}/bin/s"
cd ..
