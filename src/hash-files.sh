#!/usr/bin/env bash

usage="Usage: has-files <BASEDIR>"
basedir="${1}"

if [ "" == "${basedir}" ] ; then
    echo "No base dir given!"
    echo $usage
    exit 1
fi

if [ ! -d "${basedir}" ] ; then 
    echo "Not a directory ${basedir}!"
    echo $usage
    exit 1
fi

find "${basedir}" -type f -exec sha256 {} \; > "${basedir}/.checksums"
