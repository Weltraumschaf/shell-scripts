#!/usr/bin/env bash

set -e
usage="Usage: dircmp <left-dir> <riught-dir>"

if [ "" == "${1}" ] ; then
    echo "Left direcotry missing!"
    echo "${usage}"
    exit 1
fi

left="${1}"

if [ "" == "${2}" ] ; then
    echo "Right direcotry missing!"
    echo "${usage}"
    exit 2
fi

right="${2}"

# The comparison works as:
# 1. Find all files (no directories) in given direcotry.
# 2. Remove the direcotry prefix from find.
# 3. Sort the resulting file list.
# 4. Compare these sorted list with diff via process substitution.
diff \
    <(find "${left}" -type f | sed "s|^${left}/||" | sort) \
    <(find "${right}" -type f | sed "s|^${right}/||" | sort)
