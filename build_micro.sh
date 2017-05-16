#!/bin/sh
# build target rootfs only with programs required for boot

source ./config.sh
source ./_build_vars.sh

[ -z "${ALL_STATIC}" ] && (sh build_musl.sh || exit 1)
sh build_busybox.sh || exit 1
sh build_uinit.sh || exit 1
sh build_rc.sh || exit 1
[ -z "${NOKERN}" ] && (sh build_kern.sh || exit 1)
sh build_super.sh || exit 1
sh build_lynxbase.sh || exit 1
sh build_misc.sh || exit 1
sh build_emb.sh || exit 1
sh build_strip.sh
sh build_post.sh
