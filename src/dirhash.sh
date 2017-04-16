#!/usr/bin/env bash

set -e
set -u

usage="Usage: dirhash <BASEDIR>"
basedir="${1}"
startTime=$SECONDS
hashCmd=""

if [ "$(which sha256)" != "" ] ; then
    hashCmd="sha256"
elif [ "$(which shasum)" != "" ] ; then
    hashCmd="shasum -a 256"
else
    echo "There is no sha command available!"
    exit 1
fi

if [ "" == "${basedir}" ] ; then
    echo "No base dir given!"
    echo "${usage}"
    exit 2
fi

basedir=$(realpath "${basedir}")

if [ ! -d "${basedir}" ] ; then
    echo "Not a directory ${basedir}!"
    echo "${usage}"
    exit 3
fi

checksumFile="${basedir}/.checksums"

echo "Hash all files in ${basedir} with ${hashCmd} ..."

if [ -e "${checksumFile}" ]; then
    echo "Remove old checksum file ${checksumFile}."
    rm "${checksumFile}"
fi

echo "Start checksumming. May take a while ..."
# Find all fie but not hidden files (start with .).
find "${basedir}" -type f ! -iname ".*" -print0 | \
    xargs -0 -n1 -P4 $hashCmd \
    > "${checksumFile}"

echo "Checksums written to ${checksumFile}."
elapsedTime=$(($SECONDS - $startTime))
echo "Done in ${elapsedTime} seconds :-)"