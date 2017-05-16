#!/bin/sh
# build target rootfs just without toolchain embedded

source ./config.sh
source ./_build_vars.sh

[ -z "${ALL_STATIC}" ] && (sh build_musl.sh || exit 1)
sh build_busybox.sh || exit 1
sh build_uinit.sh || exit 1
sh build_rc.sh || exit 1
[ -z "${NOKERN}" ] && (sh build_kern.sh || exit 1)
sh build_ip.sh || exit 1
sh build_super.sh || exit 1
sh build_lynxbase.sh || exit 1
sh build_misc.sh || exit 1
case ${PARCH} in
	i*86|x86_64) (sh build_lilo_x86.sh || exit 1) ;;
esac
sh build_emb.sh || exit 1
sh build_strip.sh
sh build_post.sh
