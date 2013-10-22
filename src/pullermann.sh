#!/bin/bash

CWD=`pwd`

echo "Pulling all repos in ${CWD}..."

for repo in $(ls -1)
do
    echo "Try to pull ${CWD}/${repo}"
    
    if [ -d "${CWD}/${repo}" ]; then 
        cd "${CWD}/${repo}" && git checkout master && git pull origin master
    fi
done

cd $CWD
echo "done :)"
