#!/bin/sh
source ./config.sh
source ./_build_vars.sh
source ./_build_dirs.sh

[ -d hexedit ] && exit 0

tar -zxf "${EXTDIR}"/hexedit-1.2.12.src.tgz || exit 1
cd hexedit
tar -zxf "${EXTDIR}"/ncurses-5.9.tar.gz || exit 1
cd ncurses-5.9
cp -f "${EXTDIR}"/ncurses-fallback.c ncurses/fallback.c || exit 1
./configure --host=${TARGET} --prefix= --with-normal --without-tests --without-shared --enable-sigwinch \
	--with-fallbacks="linux vt100 xterm xterm256-color" --includedir=/include --mandir=/man \
	--disable-nls --without-dlsym --without-cxx-binding --enable-widec CFLAGS="-D_GNU_SOURCE -O0 -fPIC" || exit 1
make || exit 1
_NCURSESDIR="${PWD}/_ncurses"
make DESTDIR="${_NCURSESDIR}" install
for lib in ncurses form menu panel; do
	ln -sf lib${lib}w.a "${_NCURSESDIR}"/lib/lib${lib}.a
done
cd ..
./configure --host=${TARGET} --prefix= CFLAGS=-I"${_NCURSESDIR}"/include LDFLAGS=-L"${_NCURSESDIR}"/lib || exit 1
make || exit 1
cp -a hexedit "${ROOTDIR}"/bin/ || exit 1
mkdir -p "${ROOTDIR}"/man/man1 || exit 1
cp -a hexedit.1 "${ROOTDIR}"/man/man1 || exit 1
cd ..
