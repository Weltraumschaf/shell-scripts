#!/bin/bash

#
# This script iterates over all directories which re a Git repository and
# prints a shor status for that.
#

CWD=$(pwd)

for dir in $(ls -1 .) ; do
  if [ "${dir}" != "." ] && [ "${dir}" != ".." ] && [ -d "${dir}/.git" ] ; then
    echo -n "${dir}:"
    repo="${CWD}/${dir}"
    cd "${repo}"
    git status -sb
    cd "${CWD}"
  fi
done
