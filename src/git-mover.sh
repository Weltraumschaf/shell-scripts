#!/usr/bin/env bash

#
# Finds files by pattern and moves them to another base directory by
# maintaining the subdirectory structure.
#

usage="Usage: git-mover <search-dir> <search-pattern> <target-dir>"

searchDir=""
searchPattern=""
targetDir=""

if [ "${1}" != "" ] ; then
    searchDir="${1}"
else 
    echo "No <search-dir> given!"
    echo "${usage}"
    exit 1
fi

if [ "${2}" != "" ] ; then
    searchPattern="${2}"
else 
    echo "No <search-pattern> given!"
    echo "${usage}"
    exit 3
fi

if [ "${3}" != "" ] ; then
    targetDir="${3}"
else 
    echo "No <target-dir> given!"
    echo "${usage}"
    exit 3
fi

echo "Searching files with pattern '${searchPattern}' in ${searchDir} ..."

for sourceFile in $(find ${searchDir} -type f -name ${searchPattern}); do
    targetFile="${targetDir}${sourceFile#$searchDir}"
    dir=$(dirname "${targetFile}")
    
    if [ ! -d "${dir}" ] ; then
        mkdir -pv "${dir}"
    fi
    
    echo "Found: ${sourceFile} -> ${targetFile}"
    git mv "${sourceFile}" "${targetFile}"
done

echo "Done :-)"