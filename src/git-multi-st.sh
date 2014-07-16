#!/bin/bash

#
# This script iterates over all directories which re a Git repository and
# prints a shor status for that.
#

CWD=$(pwd)
HAS_CHANGES=0

for repo in $(ls -1 .) ; do
  if [ "${repo}" != "." ] && [ "${repo}" != ".." ] && [ -d "${repo}/.git" ] ; then
    cd "${CWD}/${repo}"

    if [ -n "$(git status --porcelain)" ] ; then
      HAS_CHANGES=1
      status=$(git status -sb --untracked-files=all)

      echo -en "${repo}\t"
      size=${#repo}

      if [ $size -lt 8 ] ; then
        echo -en "\t"
      fi

      if [ $size -lt 16 ] ; then
        echo -en "\t"
      fi

      echo "${status}"
    fi

    cd "${CWD}"
  fi
done

if [ $HAS_CHANGES == 0 ] ; then
  echo "No changes at all."
fi
