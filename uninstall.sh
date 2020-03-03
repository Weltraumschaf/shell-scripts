#!/usr/bin/env bash

##
## Uninstalls the scripts from $HOME/bin by removing the symlinks.
##

set -eu

# @see: http://wiki.bash-hackers.org/syntax/shellvars
[ -z "${SCRIPT_DIRECTORY:-}" ] \
    && SCRIPT_DIRECTORY="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )" \
    && export SCRIPT_DIRECTORY

sourceDir=$(realpath "${SCRIPT_DIRECTORY}")
sourceDir="${sourceDir}/src"
targetDir="${HOME}/bin"

##
## Removes link from target directory.
##
## @param $1 source script
## @param $2 target direcotry
##
function unlink_file {
    targetFile="${1##*/}"
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
