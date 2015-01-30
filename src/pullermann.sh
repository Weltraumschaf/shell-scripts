#!/bin/bash

#
# This script changes into all subdirectories of the current working directory
# (CWD) and pulls the given branch for that repo. If a subdirecotry is not a git
# repo it will be ommitted. Any open changes will be stashed.
#
# Usage: pullermann <BRANCHNAME>
#

function pull {
    cwd="${1}"
    repo="${2}"
    branch="${3}"

    fullPath="${cwd}/${repo}"

    if [ -d "${fullPath}" ]; then
        echo "Try to pull ${fullPath}..."
        cd "${fullPath}"

        if [ ! -d ".git" ] ; then
            echo "Not a git repo!"
            return
        fi

        stashed=false

        if [ "$(git status --porcelain)" != "" ] ; then
            git stash
            stashed=true
        fi

        git checkout "${branch}" && git pull origin "${branch}"

        if [ stashed == true ] ; then
            git stash pop
        fi
  fi
}

CWD=`pwd`
BRANCH="${1}"

if [ "${BRANCH}" == "" ]; then
    echo "No branch given! Specify branch as first argument."
    exit 1
fi

echo "Pulling branch ${BRANCH} for all repos in ${CWD}..."

for repo in $(ls -1) ; do
    pull "${CWD}" "${repo}" "${BRANCH}"
done

cd $CWD
echo "done :)"
