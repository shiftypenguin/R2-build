[ ! -d "${PKGDIR}" ] && exit 1
[ ! -d "${BUILDDIR}" ] && mkdir -p "${BUILDDIR}"
cd "${BUILDDIR}" || exit 1
