#!/usr/bin/env bash

USAGE="snapshot <pool> <custom name part>"

pool="${1}"

if [ "" == "${pool}" ] ; then
    echo "No pool given!"
    echo "${USAGE}"
    exit 1
fi

custom="${2}"

if [ "" == "${custom}" ] ; then
    echo "No custom name part given!"
    echo "${USAGE}"
    exit 1
fi

now=$(date "+%Y-%m-%dT%H%M")
name="${pool}@${now}_${custom}"

zfs snapshot -r "${name}"