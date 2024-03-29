#!/usr/bin/env bash

##
## Uninstalls the scripts from $HOME/bin by removing the symlinks.
##

set -euo pipefail

# @see: http://wiki.bash-hackers.org/syntax/shellvars
[ -z "${SCRIPT_DIRECTORY:-}" ] \
    && SCRIPT_DIRECTORY="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

sourceDir="${SCRIPT_DIRECTORY}/src"
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

    rm -fv "${target}"
}

if [ ! -d "${targetDir}" ]; then
    echo "Nothing to do."
    exit
fi

for file in "${sourceDir}/"*.sh; do
    unlink_file "${file}" "${targetDir}"
done

echo "Finished :)"
