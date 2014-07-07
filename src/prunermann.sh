#!/bin/bash

CWD=`pwd`

echo "GC and prune all repos in ${CWD}..."

for repo in $(ls -1) ; do
  fullPath="${CWD}/${repo}"

  if [ -d "${fullPath}" ] && [ -d "${fullPath}/.git" ] ; then
    cd "${fullPath}"
    echo "Expire reflog ${fullPath} ..."
    git reflog expire --expire=now --all

    echo "Try to gc/prune ${fullPath} ..."
    # Don't do --agressive http://metalinguist.wordpress.com/2007/12/06/the-woes-of-git-gc-aggressive-and-how-git-deltas-work/
    git gc --prune=now
  fi
done

cd $CWD
echo "done :)"
