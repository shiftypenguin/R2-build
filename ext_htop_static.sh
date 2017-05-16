#!/bin/sh
source ./config.sh
source ./_build_vars.sh
source ./_build_dirs.sh

[ -d htop-1.0.1 ] && exit 0

tar -zxf "${EXTDIR}"/htop-1.0.1.tar.gz || exit 1
cd htop-1.0.1
patch -Np1 -i "${EXTDIR}"/patches/htop-1.0.1-elim-dotconf.patch
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
./configure --host=${TARGET} --prefix= --enable-taskstats --disable-unicode CFLAGS=-I"${_NCURSESDIR}"/include LDFLAGS=-L"${_NCURSESDIR}/lib" || exit 1
sh -c '> scripts/MakeHeader.py'
make || exit 1
cp -a htop "${ROOTDIR}"/bin/ || exit 1
cp -a "${EXTDIR}"/scripts/htoprc "${ROOTDIR}"/etc/ || exit 1
mkdir -p "${ROOTDIR}"/man/man1 || exit 1
cp -a htop.1 "${ROOTDIR}"/man/man1 || exit 1
cd ..
