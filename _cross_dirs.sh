[ ! -d "${PKGDIR}" ] && exit 1
[ ! -d "${CROSSBUILDDIR}" ] && mkdir -p "${CROSSBUILDDIR}"
cd "${CROSSBUILDDIR}" || exit 1
