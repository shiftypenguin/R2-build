#!/bin/sh
source ./config.sh
source ./_build_vars.sh

sh build_musl.sh || exit 1
sh build_binutils.sh || exit 1
sh build_gcc.sh || exit 1
sh build_make.sh || exit 1
sh build_busybox.sh || exit 1
sh build_uinit.sh || exit 1
sh build_rc.sh || exit 1
if [ -n "${NOKERN}" ]; then
	(sh build_headers.sh || exit 1)
else
	(sh build_kern.sh || exit 1)
fi
sh build_ip.sh || exit 1
sh build_super.sh || exit 1
sh build_lynxbase.sh || exit 1
sh build_misc.sh || exit 1
case ${PARCH} in
	i*86|x86_64) (sh build_lilo_x86.sh || exit 1) ;;
esac
sh build_oport.sh || exit 1
sh build_e2fsprogs.sh || exit 1
sh build_emb.sh || exit 1
sh build_strip.sh
sh build_post.sh
