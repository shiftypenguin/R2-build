[ -z "${PKGDIR}" ] && export PKGDIR="${PWD}/pkg"

[ -z "${CROSSDIR}" ] && export CROSSDIR="${PWD}/cross"
[ -z "${CROSSBUILDDIR}" ] && export CROSSBUILDDIR="cross_obj"
export PATH=${CROSSDIR}/bin:${PATH}

export PARCH="$(echo ${TARGET} | cut -d'-' -f1)"
export PTARGET="${PARCH}-"

make()
{
	if [ -n "${MAKEOPTS}" ]; then
		env make "${MAKEOPTS}" "${@}"
	else
		env make "${@}"
	fi
}
