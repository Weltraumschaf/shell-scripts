#!/usr/bin/env bash

##
## Uninstalls the scripts from $HOME/bin by removing the symlinks.
##

targetDir="${HOME}/bin"
sourceDir="src/*.sh"

##
## Removes link from target directory.
##
## @param $1 source script
## @param $2 target direcotry
##
function unlinkFile {
    targetFile="${1/src\//}"
    targetFile="${targetFile/\.sh/}"
    target="${2}/${targetFile}"

    rm -v "${target}"
}

if [ ! -d "${targetDir}" ]; then
    echo "Nothing to do."
    exit
fi

for file in ${sourceDir}
do
  unlinkFile "${file}" "${targetDir}"
done

echo "Finished :)"
