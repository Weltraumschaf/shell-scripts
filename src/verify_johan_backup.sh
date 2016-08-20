#!/usr/bin/env sh

CWD=$(pwd)

cd /storage/backups/johan.weltraumschaf.de
tar xvf "${1}"

cd backup/
find . -name "*.bz2" | xargs pbunzip2 -v

cd "${CWD}"
