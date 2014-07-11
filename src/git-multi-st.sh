#!/bin/bash

#
# This script iterates over all directories which re a Git repository and
# prints a shor status for that.
#

CWD=$(pwd)

for dir in $(ls -1 .) ; do
  if [ "${dir}" != "." ] && [ "${dir}" != ".." ] && [ -d "${dir}/.git" ] ; then
    echo -en "${dir}\t"
    size=${#dir}

    if [ $size -lt 8 ] ; then
      echo -en "\t"
    fi

    if [ $size -lt 16 ] ; then
      echo -en "\t"
    fi

    repo="${CWD}/${dir}"
    cd "${repo}"
    git status -sb
    cd "${CWD}"
  fi
done
