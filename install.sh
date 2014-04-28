#!/bin/bash

##
## Installs the scripts in $HOME/bin by symlinking them.
##

function linkFile {
    source="${PWD}/$1"
    targetFile="${1/src\//}"
    targetFile="${targetFile/\.sh/}"
    target="${2}/${targetFile}"

    # Only create backup if target is a file or directory
    if [ -f "${target}" ] || [ -d "${target}" ]; then
        if [ ! -L "${target}" ]; then
        	echo "Backing up ${target}"
            mv -v "${target}" "${target}.bak"
        fi
    fi

    ln -svf "${source}" "${target}"
}

targetDir="${HOME}/bin"

if [ ! -d "${targetDir}" ]; then
    mkdir -vp "${targetDir}"
fi

for i in src/*.sh
do
  linkFile "$i" "${targetDir}"
done