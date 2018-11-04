#!/usr/bin/env bash

set -eu

##
## Installs the scripts to $HOME/bin by symlinking them.
## Already existing inks are backupped.
##

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
sourceDir=$(dirname "${program}")
sourceDir="${sourceDir}/src"

##
## Links source file into target directory.
## Makes backup if target link already exists.
##
## @param $1 source script
## @param $2 target direcotry
##
function link_file {
    source="${1}"
    target="${source##*/}"
    echo "${target}"
    target="${target/\.sh/}"
    echo "${target}"
    target="${2}/${target}"
    echo "${target}"
    echo "Install ${source} to ${target} ..."

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

for file in "${sourceDir}/"*.sh; do
    link_file "${file}" "${targetDir}"
done

echo "Finished :)"
