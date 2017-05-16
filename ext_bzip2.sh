#!/bin/sh
source ./config.sh
source ./_build_vars.sh
source ./_build_dirs.sh

[ -d bzip2-1.0.6.st ] && exit 0

tar -zxf "${EXTDIR}"/bzip2-1.0.6.tar.gz || exit 1
mv bzip2-1.0.6 bzip2-1.0.6.st
cd bzip2-1.0.6.st
sed -i 's@$(PREFIX)@$(DESTDIR)$(PREFIX)@g' Makefile
sed -i 's@$(PREFIX)/man@$(PREFIX)/share/man@g' Makefile
sed -i 's@ln -s -f $(DESTDIR)$(PREFIX)@ln -s -f @g' Makefile
make CC=${TARGET}-gcc AR=${TARGET}-ar RANLIB=${TARGET}-ranlib libbz2.a bzip2 bzip2recover || exit 1
make DESTDIR="${ROOTDIR}" PREFIX=/ install || exit 1
cd ..
