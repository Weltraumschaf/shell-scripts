#!/usr/bin/env bash

##
## Creates a ramdisk.
##
## Usage:
## $> createramdisk-debian <DIR> <SIZE>
##
## Example
## $> createramdisk-debian /var/ramdisk 1024M
##

USAGE="createramdisk-debian <DIR> <SIZE>"


if [ "${1}" == "" ] ; then
  echo "No direcotry given!"
  echo "${USAGE}"
  exit 1
fi

RAM_DIR="${1}"

if [ "${2}" == "" ] ; then
  echo "No sizey given!"
  echo "${USAGE}"
  exit 1
fi

SIZE="${2}"

mkdir -p "${RAM_DIR}"
mount -t tmpfs -o size="${SIZE}" tmpfs "${RAM_DIR}"