#!/bin/bash

##
## Installs the scripts in $HOME/bin by symlinking them.
##

function linkFile {
    source="${PWD}/$1"
    targetDir="${HOME}/bin"
    targetFile="${1/src\//}"
    targetFile="${targetFile/\.sh/}"
    target="${targetDir}/${targetFile}"

    # Only create backup if target is a file or directory
    if [ -f "${target}" ] || [ -d "${target}" ]; then
    	echo "Backing up port-remove.sh"
        mv "$target" "$target.bak"
    fi

    ln -sf "${source}" "${target}"
}

for i in src/*.sh
do
  linkFile "$i"
done