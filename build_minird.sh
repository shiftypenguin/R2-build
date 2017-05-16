#!/bin/sh
# Build initramfs image

source ./config.sh
source ./_build_vars.sh
source ./_build_dirs.sh

mkdir minird || exit 1
cd minird

cat >init <<EOF
#!/bin/sh
export PATH=/bin:/sbin
/bin/busybox --install -s
/smdev
exec execvp /bin/sh -sh
EOF
chmod +x init

mkdir bin dev lib proc sbin sys mnt
mkdir -m1777 tmp
ln -s / usr

if [ -z "${ALL_STATIC}" ]; then
	cp -a "${ROOTDIR}"/lib/libc.so "${ROOTDIR}"/lib/sldl lib
fi
cp -a "${ROOTDIR}"/bin/busybox "${ROOTDIR}"/bin/mke2fs "${ROOTDIR}"/bin/execvp bin
if [ -f "${ROOTDIR}/bin/ip" ]; then
	cp -a "${ROOTDIR}"/bin/ip "${ROOTDIR}"/bin/ss bin
fi
cp -a "${ROOTDIR}"/sbin/smdev .
ln -s busybox bin/sh

find . | cpio -o -H newc | gzip -9nc >"${ROOTDIR}"/boot/minird.gz

cd ..
