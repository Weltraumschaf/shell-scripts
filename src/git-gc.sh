#!/bin/bash

CWD=$(pwd)

for dir in $(ls -1 .) ; do
    if [ "${dir}" != "." ] && [ "${dir}" != ".." ] ; then
        cd "./${dir}"
        echo "Change into ${dir}"

        if [ -d "./.git" ] ; then
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
