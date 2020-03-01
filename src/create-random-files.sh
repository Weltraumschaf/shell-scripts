#!/usr/bin/env bash

set -eu

COUNG="${1:-10}"
CWD=$(pwd)

echo "Creating $COUNG files in $CWD ..."

for n in $(seq 1 $COUNG); do
    filename="${CWD}/file$( printf %03d "$n" )"
    kbytes=$(shuf -i 1-1024 -n 1)
    dd  if=/dev/urandom of="$filename" bs=1 count=$(( kbytes * 1024 ))
done