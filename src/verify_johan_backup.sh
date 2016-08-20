#!/usr/bin/env sh

set -e

BACKUP_TO_VERIFY="${1}"

if [ "${BACKUP_TO_VERIFY}" == "" ] ; then
    echo "No backup given to verify!"
    exit 1
fi

if [ ! -e "${BACKUP_TO_VERIFY}" ] ; then
    echo "File does not exist ${BACKUP_TO_VERIFY}!"
    exit 2
fi

CWD=$(pwd)

cd /storage/backups/johan.weltraumschaf.de
tar xvf "${BACKUP_TO_VERIFY}"

cd backup/
find . -name "*.bz2" | xargs pbunzip2 -v

cd "${CWD}"
