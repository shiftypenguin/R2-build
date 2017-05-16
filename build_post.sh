#!/bin/sh

source ./config.sh
source ./_build_vars.sh
source ./_build_dirs.sh

for _dir in bin boot dev etc lib mnt proc root sbin sys tmp var var/log var/run data; do
	mkdir -p "${ROOTDIR}/${_dir}"
done
for _dir in src data local local/bin local/sbin local/lib local/include local/man local/share local/doc; do
	mkdir -p "${ROOTDIR}${USRDIR}/${_dir}"
done
touch "${ROOTDIR}/var/log/dmesg"; chmod 600 "${ROOTDIR}/var/log/dmesg"
chmod 0750 "${ROOTDIR}/root"
chmod 1777 "${ROOTDIR}/tmp"

if [ -n "${ROOTDIR}" ]; then
	fork rm -r "${ROOTDIR}${USRDIR}/share/info" "${ROOTDIR}${USRDIR}/info"
	find "${ROOTDIR}" -type f -name "*.la" -delete
fi

cat > "${ROOTDIR}/etc/passwd" << EOF
root::0:0:root:/root:/bin/sh
bin:x:1:1:binaries:/src:/bin/sh
nobody:x:65535:65535:nobody:/dev/null:/bin/false
EOF

cat > "${ROOTDIR}/etc/group" << EOF
root:x:0:
bin:x:1:
tty:x:4:
floppy:x:7:
disk:x:8:
dialout:x:10:
audio:x:11:
video:x:12:
cdrom:x:15:
log:x:16:
wheel:x:200:
nobody:x:65535:
nogroup:x:65534:
EOF

touch "${ROOTDIR}"/etc/shadow
chmod 600 "${ROOTDIR}"/etc/shadow

mkdir -p -m711 "${ROOTDIR}/etc/tcb"

cat > "${ROOTDIR}/etc/tcb/shadow.example" << EOF
user:x:15440:0:99999:7:::
EOF

chmod 600 "${ROOTDIR}/etc/tcb/shadow.example"

cp -a "${PKGDIR}"/scripts/profile "${ROOTDIR}/etc"

cat > "${ROOTDIR}/etc/syslog.conf" << EOF
auth,authpriv.* /var/log/auth.log
daemon.* /var/log/daemon.log
kern.* /var/log/kern.log
mail.* /var/log/mail.log
user.* /var/log/user.log
cron.* /var/log/cron.log
*.emerg *
EOF

touch "${ROOTDIR}/var/log/messages"; chmod 640 "${ROOTDIR}/var/log/messages"
touch "${ROOTDIR}/var/log/auth.log"; chmod 640 "${ROOTDIR}/var/log/auth.log"
touch "${ROOTDIR}/var/log/daemon.log"; chmod 640 "${ROOTDIR}/var/log/daemon.log"
touch "${ROOTDIR}/var/log/kern.log"; chmod 640 "${ROOTDIR}/var/log/kern.log"
touch "${ROOTDIR}/var/log/mail.log"; chmod 640 "${ROOTDIR}/var/log/mail.log"
touch "${ROOTDIR}/var/log/user.log"; chmod 640 "${ROOTDIR}/var/log/user.log"
touch "${ROOTDIR}/var/log/cron.log"; chmod 640 "${ROOTDIR}/var/log/cron.log"

cat > "${ROOTDIR}/etc/fstab" << EOF
/dev/root	/	auto	defaults		0	0
tmpfs		/tmp	tmpfs	nodev,nosuid,defaults	0	0
EOF

cp -a "${PKGDIR}"/scripts/xless "${PKGDIR}"/scripts/xtrue "${PKGDIR}"/scripts/view "${PKGDIR}"/scripts/psu "${PKGDIR}"/scripts/null "${PKGDIR}"/scripts/la "${PKGDIR}"/scripts/ll "${PKGDIR}"/scripts/dl "${PKGDIR}"/scripts/u "${PKGDIR}"/scripts/cll "${PKGDIR}"/scripts/title "${ROOTDIR}/bin"
cp -a "${PKGDIR}"/scripts/smdev "${PKGDIR}"/scripts/ttysh "${PKGDIR}"/scripts/dreboot "${PKGDIR}"/scripts/dpoweroff "${ROOTDIR}/sbin"

mkdir -p "${ROOTDIR}/lib/mdev"
ln -sfn /bin/xtrue "${ROOTDIR}/lib/mdev/usbdisk_link"
ln -sfn /bin/xtrue "${ROOTDIR}/bin/makeinfo"
ln -sfn /bin/xtrue "${ROOTDIR}/sbin/fsck.auto"

[ -z "${ALL_STATIC}" ] && ln -sfn /lib/libc.so "${ROOTDIR}/bin/ldd"
if [ "${USRDIR}" == "/" ]; then
ln -sfn / "${ROOTDIR}/usr"
ln -sfn gcc "${ROOTDIR}/bin/cc"
ln -sfn /etc "${ROOTDIR}/local/etc"
else
ln -sfn "/lib/libc.so" "${ROOTDIR}${USRDIR}/lib/libc.so"
ln -sfn gcc "${ROOTDIR}${USRDIR}/bin/cc"
ln -sfn /etc "${ROOTDIR}${USRDIR}/local/etc"
fi

case ${PARCH} in
	i?86|x86_64)
cat > "${ROOTDIR}"/etc/lilo.conf << EOF
boot=/dev/sda
lba32
prompt
compact
menu-title="R2"
timeout=150

image=/boot/linux
	label=linux
	vga=ask
	append="root= ro quiet"
EOF
	;;
	*)
	;;
esac

cat > "${ROOTDIR}/post.sh" << EOF
chown -hR 0:0 /
mknod -m600 /dev/console c 5 1
mknod -m666 /dev/null c 1 3
chgrp wheel /; chmod 0751 /
chgrp bin /bin; chmod 1775 /bin
chgrp wheel /boot; chmod 0750 /boot
chmod 0555 /data
chgrp bin /etc; chmod 1771 /etc
chgrp bin /include; chmod 1775 /include
chgrp bin /lib; chmod 1775 /lib
chgrp bin /lib/pkgconfig; chmod 1775 /lib/pkgconfig
chmod 0751 /local
chgrp bin /local/bin /local/lib /local/sbin /local/include /local/man /local/share /local/doc
chmod 1771 /local/bin /local/lib /local/sbin /local/include /local/man /local/share /local/doc
chgrp bin /man; chmod 1775 /man; chgrp bin /man/*; chmod 1775 /man/*
chgrp bin /sbin; chmod 1771 /sbin
chgrp bin /share; chmod 1771 /share
chgrp bin /share/man; chmod 1775 /share/man; chgrp bin /share/man/*; chmod 1775 /share/man/*
chown -h bin:wheel /src; chmod 0750 /src
chgrp wheel /var/log; chgrp wheel /var/log/*
chmod 0751 /var; chgrp wheel /var; chmod 0751 /var/log
EOF

if [ "${USRDIR}" != "/" ]; then
	sed -i 's@ /local@ '"${USRDIR}"'/local@g' "${ROOTDIR}/post.sh"
fi

echo "On target, execute the script to create device nods and set permissions:"
echo "# sh /post.sh; rm /post.sh"
echo
echo "Root for ${PARCH} ready."
