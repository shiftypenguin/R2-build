#!/bin/sh
# m4/lex/yacc port from OpenBSD, requires installed oport or other similiar tools

source ./config.sh
source ./_build_vars.sh
source ./_build_dirs.sh

[ -d oport ] && exit 0

# Known to cause troubles when building in parallel
unset MAKEOPTS

tar -zxf "${PKGDIR}"/oport.tar.gz oport || exit 1
cd oport
sed -i -e 's@\ -static@@g' config.mk
# temporary tool for host
make -C libopenbsd || exit 1
make -C yacc || exit 1
make -C libopenbsd clean || exit 1
#
export _OPATH="${PATH}"
export PATH="${CROSSDIR}/${TARGET}/bin:${PATH}"
make CC=${TARGET}-gcc -C libopenbsd || exit 1
make CC=${TARGET}-gcc -C lex || exit 1
make CC=${TARGET}-gcc -C libl || exit 1
make CC=${TARGET}-gcc -C liby || exit 1
make CC=${TARGET}-gcc -C m4 || exit 1
make -C yacc clean || exit 1
make CC=${TARGET}-gcc -C yacc || exit 1
export PATH="${_OPATH}"
cp -f lex/lex m4/m4 yacc/yacc "${ROOTDIR}${USRDIR}"/bin
cp -f libl/libl.a liby/liby.a "${ROOTDIR}${USRDIR}"/lib
cd ..
