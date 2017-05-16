export TARGET BUILD CROSSDIR CROSSBUILDDIR ROOTDIR BUILDDIR

[ -z "${PKGDIR}" ] && export PKGDIR="${PWD}/pkg"
[ -z "${EXTDIR}" ] && export EXTDIR="${PWD}/ext"

[ -z "${CROSSDIR}" ] && export CROSSDIR="${PWD}/cross"
[ -z "${ROOTDIR}" ] && export ROOTDIR="${PWD}/root"
[ -z "${BUILDDIR}" ] && export BUILDDIR="build_obj"
[ -z "${USRDIR}" ] && export USRDIR="/"
[ -z "${BUILD}" ] && export BUILD="$(uname -m)-$(echo ${TARGET} | cut -d'-' -f2-)"

export PATH=${CROSSDIR}/bin:${PATH}

export PARCH="$(echo ${TARGET} | cut -d'-' -f1)"
export PTARGET="${PARCH}-"

make()
{
	if [ -n "${MAKEOPTS}" ]; then
		env make ${MAKEOPTS} "${@}"
	else
		env make "${@}"
	fi
}
