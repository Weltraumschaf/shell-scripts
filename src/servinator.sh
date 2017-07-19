#!/usr/bin/env bash

set -e
set -u

usage="Usage: ${0} <input-file> <output-dir>"
example="Example: ${0} src/main/resources/services.properties src/main/resources/META-INF/services"

function help {
    echo "${usage}"
    echo "${example}"
}

inputFile="${1-}"
if [ "${inputFile}" == "" ]; then
    echo "No input file given!"
    echo
    help
    exit 1
fi

outputDir="${2-}"

if [ "${outputDir}" == "" ]; then
    echo "No output dir given!"
    echo
    help
    exit 2
fi

if [ ! -e "${outputDir}" ]; then
    mkdir -pv "${outputDir}"
fi

if [ ! -d "${outputDir}" ]; then
    echo "${outputDir} is not a direcotry!"
    exit 3
fi

cat "${inputFile}" | while read line; do
    interface=$(echo "${line}" | cut -d '=' -f 1)
    implementation=$(echo "${line}" | cut -d '=' -f 2)
    echo "${implementation}" > "${outputDir}/${interface}"
done 

echo 'Done :-)'