#!/bin/bash

CWD=`pwd`

echo "GC and prune all repos in ${CWD}..."

for repo in $(ls -1)
do
    fullPath="${CWD}/${repo}"
    
    if [ -d "${fullPath}" ]; then 
        echo "Try to pull ${fullPath}..."
        cd "${fullPath}" && git gc --aggressive --prune=all
    fi
done

cd $CWD
echo "done :)"
