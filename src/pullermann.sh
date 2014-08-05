#!/bin/bash

CWD=`pwd`
BRANCH="${1}"

if [ "${BRANCH}" == "" ]; then
    echo "No branch given! Specify branch as first argument."
    exit 1
fi

echo "Pulling branch ${BRANCH} for all repos in ${CWD}..."

for repo in $(ls -1)
do
    fullPath="${CWD}/${repo}"

    if [ -d "${fullPath}" ]; then
        echo "Try to pull ${fullPath}..."
        cd "${fullPath}"
        stashed=false

        if [ "$(git status --porcelain)" != "" ] ; then
          git stash
          stashed=true
        fi

        git checkout "${BRANCH}" && git pull origin "${BRANCH}"

        if [ stashed == true ] ; then
          git stash pop
        fi
    fi
done

cd $CWD
echo "done :)"
