#!/usr/bin/env bash

# http://sleepyhead.de/howto/?href=crypt

if [ "${1}" == "" ]; then
    echo "No input file given!"
    exit 1
fi

IN_FILE="${1}"

echo "Dencrypting file ${IN_FILE} ..."
openssl aes-256-cbc -d -salt -in "${IN_FILE}" -out "${IN_FILE%.aes}"
