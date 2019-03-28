#!/usr/bin/env bash

set -ue

local_branch="${1:-}"

if [ "${local_branch}" = "" ]; then
    echo "No branch given!"
    echo "Usage: $(basename ${0}) <local branch>"
    exit 1
fi

git stash && \
git co master && \
git pull origin master && \
git co "${local_branch}" && \
git rebase master && \
git co master && \
git merge "${local_branch}" && \
git push origin master && \
git co "${local_branch}" && \
git stash pop
