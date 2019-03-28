#!/usr/bin/env bash

##
## Uninstalls the scripts from $HOME/bin by removing the symlinks.
##

set -eu

program="${0}"

while [ -h "${program}" ]; do
    ls=$(ls -ld "${program}")
    link=$(expr "${ls}" : '.*-> \(.*\)$')

    if expr "${link}" : '.*/.*' > /dev/null; then
        program="${link}"
    else
        program=$(dirname "${program}")/"${link}"
    fi
done

targetDir="${HOME}/bin"
sourceDir=$(realpath "${program}")
sourceDir=$(dirname "${sourceDir}")
sourceDir="${sourceDir}/src"

##
## Removes link from target directory.
##
## @param $1 source script
## @param $2 target direcotry
##
function unlink_file {
    targetFile="${1/src\//}"
    targetFile="${targetFile/\.sh/}"
    target="${2}/${targetFile}"

    rm -v "${target}"
}

if [ ! -d "${targetDir}" ]; then
    echo "Nothing to do."
    exit
fi

for file in "${sourceDir}/"*.sh; do
    unlink_file "${file}" "${targetDir}"
done

echo "Finished :)"
