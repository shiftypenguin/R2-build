#!/bin/sh
source ./config.sh
source ./_build_vars.sh
source ./_build_dirs.sh

[ -d dropbear-2014.65 ] && exit 0

tar -jxf "${EXTDIR}"/dropbear-2014.65.tar.bz2 || exit 1
cd dropbear-2014.65
patch -Np1 -i "${EXTDIR}"/patches/dropbear-2014.65-no-hackcrypt.patch
patch -Np1 -i "${EXTDIR}"/patches/dropbear-2014.65-no-garbage.patch
patch -Np1 -i "${EXTDIR}"/dropbear-2014.65-ouropts.diff
./configure --host=${TARGET} --disable-zlib --disable-loginfunc --disable-utmp \
	--disable-utmpx --disable-wtmp --disable-wtmpx --disable-pututline --disable-pututxline \
	--disable-lastlog --prefix= || exit 1
make MULTI=1 PROGRAMS="dropbear dropbearkey scp dbclient" || exit 1
cp -a dropbearmulti "${ROOTDIR}"/sbin
for prg in dropbear dropbearkey scp dbclient; do
	ln -sf ../sbin/dropbearmulti "${ROOTDIR}"/bin/${prg}
done
mkdir -p -m750 "${ROOTDIR}"/etc/dropbear
cp -a "${EXTDIR}"/scripts/dropbear.init "${ROOTDIR}"/etc/init/rc.sshd
echo /bin/sh >"${ROOTDIR}"/etc/shells
cd ..
