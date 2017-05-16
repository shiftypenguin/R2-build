#!/bin/sh
source ./config.sh
source ./_build_vars.sh

sh build_musl.sh || exit 1
sh build_binutils.sh || exit 1
sh build_gcc.sh || exit 1
sh build_make.sh || exit 1
sh build_busybox.sh || exit 1
sh build_headers.sh || exit 1
sh build_super.sh || exit 1
sh build_lynxbase.sh || exit 1
sh build_misc.sh || exit 1
sh build_oport.sh || exit 1
sh build_strip.sh
sh build_post.sh
