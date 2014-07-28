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
        cd "${fullPath}" \
          && git stash \
          && git checkout "${BRANCH}" \
          && git pull origin "${BRANCH}" \
          && git stash pop
    fi
done

cd $CWD
echo "done :)"
