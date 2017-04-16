#!/usr/bin/env bash

usage="Usage: dirhash <BASEDIR>"
basedir="${1}"
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

if [ ! -d "${basedir}" ] ; then
    echo "Not a directory ${basedir}!"
    echo "${usage}"
    exit 3
fi

find "${basedir}" -type f ! -iname ".*" -print0 | \
    xargs -0 -n1 -P4 $hashCmd \
    > "${basedir}/.checksums"
