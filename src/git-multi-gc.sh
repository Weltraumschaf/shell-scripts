#!/bin/bash

#
# Expires the reflog and performe an GC in each git repository in the
# current work direcotry.
#

CWD=$(pwd)

for dir in $(ls -1 .) ; do
    if [ "${dir}" != "." ] && [ "${dir}" != ".." ] ; then
        repo="${CWD}/${dir}"
        echo "Change into ${repo}"
        cd "${repo}"

        if [ -d ".git" ] ; then
            echo "Expire reflog ..."
            git reflog expire --expire=now --all
            echo "Collect garbage ..."
            git gc --prune=now
        else
            echo "Not a git repo! Skipping."
        fi

        cd "${CWD}"
    fi
done

echo "Finished :-)"
