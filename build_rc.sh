#!/bin/sh

source ./config.sh
source ./_build_vars.sh
source ./_build_dirs.sh

tar -C"${ROOTDIR}" -zxf "${PKGDIR}"/uinit_rc.tar.gz etc
cp -a "${PKGDIR}"/scripts/ntpd.init "${ROOTDIR}"/etc/init/rc.ntpd
cat > "${ROOTDIR}"/etc/init/altinit << EOF
#!/bin/sh
/bin/clear
exec /bin/env - _INIT=1 HOME=/ TERM=linux /sbin/init
EOF
chmod 754 "${ROOTDIR}"/etc/init/altinit
