#!/usr/bin/env bash

# https://stackoverflow.com/questions/67699/how-do-i-clone-all-remote-branches-with-git

for branch in $(git branch -a | grep remotes | grep -v HEAD | grep -v master); do
    git branch --track ${branch##*/} $branch
done

git fetch --all
git pull --all
