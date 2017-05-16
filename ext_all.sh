#!/bin/sh
source ./config.sh
source ./_build_vars.sh

sh ext_gsed.sh || exit 1
sh ext_patch.sh || exit 1
[ -n "${ALL_STATIC}" ] && (sh ext_zlib.sh || exit 1)
[ -z "${ALL_STATIC}" ] && (sh ext_zlib_so.sh || exit 1)
sh ext_bzip2.sh || exit 1
[ -z "${ALL_STATIC}" ] && (sh ext_bzip2_so.sh || exit 1)
sh ext_file.sh || exit 1
sh ext_bash.sh || exit 1
case ${PARCH} in
	i*86|x86_64) (sh ext_memtest86+.sh || exit 1) ;;
esac
sh ext_dropbear.sh || exit 1
sh ext_iptables.sh || exit 1
sh ext_ncurses.sh || exit 1
sh ext_hexedit.sh || exit 1
sh ext_htop.sh || exit 1
sh ext_tcpdump.sh || exit 1
sh ext_mini-httpd.sh || exit 1
sh ext_libressl.sh || exit 1
sh ext_tinc.sh || exit 1
sh ext_mansys.sh || exit 1
