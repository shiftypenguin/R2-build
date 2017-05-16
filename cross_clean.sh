#!/bin/sh

source ./config.sh
source ./_cross_vars.sh
source ./_cross_dirs.sh

find "${CROSSDIR}" -type f -name "*.la" -delete

echo "You should have cross tools now located in ${CROSSDIR}."
