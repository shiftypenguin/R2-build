#!/bin/sh
source ./config.sh
source ./_cross_vars.sh

sh cross_binutils.sh || exit 1
sh cross_gcc.sh || exit 1
sh cross_headers.sh || exit 1
sh cross_musl.sh || exit 1
case ${PARCH} in
	i*86|x86_64) sh cross_dev86_x86.sh || exit 1 ;; # for lilo on x86
esac
[ -n "${BUILD_CROSS}" ] && sh cross_fullgcc.sh
sh cross_clean.sh
