#!/bin/sh

source ./config.sh
source ./_build_vars.sh
source ./_build_dirs.sh

[ -d ncurses-5.9 ] && exit 0

_shared="--without-shared"
tar -zxf "${EXTDIR}"/ncurses-5.9.tar.gz || exit 1
cd ncurses-5.9
cp -f "${EXTDIR}"/ncurses-fallback.c ncurses/fallback.c || exit 1
[ -z "${ALL_STATIC}" ] && _shared="--with-shared"
printf '%s\n%s\n' '#!/bin/sh' 'echo '"$BUILD" >config.guess # stupid autotools workarounds
./configure --host=${TARGET} --prefix= --with-normal --without-tests ${_shared} --enable-sigwinch \
	--with-fallbacks="linux vt100 xterm xterm256-color" --includedir=/include --mandir=/man \
	--disable-nls --without-dlsym --without-cxx-binding --enable-widec CC=${TARGET}-gcc AR=${TARGET}-ar RANLIB=${TARGET}-ranlib LD=${TARGET}-ld CFLAGS="-D_GNU_SOURCE -O0 -fPIC" || exit 1
make || exit 1
make DESTDIR="${ROOTDIR}" install
for lib in ncurses form menu panel; do
	ln -sf lib${lib}w.a "${ROOTDIR}"/lib/lib${lib}.a
done
if [ -z "${ALL_STATIC}" ]; then
	for lib in ncurses form menu panel; do
		ln -sf lib${lib}w.so "${ROOTDIR}"/lib/lib${lib}.so
		ln -sf lib${lib}w.so.5 "${ROOTDIR}"/lib/lib${lib}.so.5
		ln -sf lib${lib}w.so.5.9 "${ROOTDIR}"/lib/lib${lib}.so.5.9
	done
fi
cd ..
