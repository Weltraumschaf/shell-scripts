#!/usr/bin/env bash

set -eu

usage="$(basename "${0}") <filename>"
input_file="${1:-}"

if [ "" = "${input_file}" ]; then
    echo "Please provide the file name to decrypt."
    echo "${usage}"
    exit 1
fi

output_file="${input_file%.enc}"
read -rsp "Enter Password: " password
echo

if [ -e "${output_file}" ]; then
    echo "Output file ${output_file} already exists!"
    read -rep "Overwrite the file? [Y/n]" answer

    if [ "n" = "${answer}" ] || [ "n" = "${answer}" ]; then
        exit 2
    fi
fi

openssl aes-256-cbc -salt -d -k "${password}" -in "${input_file}" -out "${output_file}"

echo "File decrypted into: ${output_file}"
