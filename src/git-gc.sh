#!/bin/bash

for dir in $(ls -1 .) ; do
    if [ "${dir}" != "." ] && [ "${dir}" != ".." ] ; then
        cd "./${dir}"
        echo "Change into ${dir}"
        
        if [ -d "./.git" ] ; then
            echo "Collect garbage..."
            git gc --aggressive --prune=now
        else
            echo "Not a git repo. Skipping."
        fi
        
        cd ..
    fi
done

echo "Finished :-)"