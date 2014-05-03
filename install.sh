#!/bin/bash

##
## Installs the scripts to $HOME/bin by symlinking them.
## Already existing inks are backupped.
##

targetDir="${HOME}/bin"
sourceDir="src/*.sh"

##
## Links source file into target directory.
## Makes backup if target link already exists.
##
## @param $1 source script
## @param $2 target direcotry
##
function linkFile {
    source="${PWD}/${1}"
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

if [ ! -d "${targetDir}" ]; then
    echo "Make target directory ${targetDir} ..."
    mkdir -vp "${targetDir}"
fi

for file in ${sourceDir}
do
  linkFile "${file}" "${targetDir}"
done

echo "Finished :)"
