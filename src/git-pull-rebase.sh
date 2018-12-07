#!/usr/bin/env bash

branch="${1:-}"

if [ "${branch}" = "" ]; then
    echo "No branch given!"
    echo "Usage: ${0} branch"
    exit 1
fi

git co master && \
    git pull && \
    git co "${branch}" && \
    git rebase master && \
    git co master && \
    git merge "${branch}" && \
    git push && \
    git co "${branch}"
