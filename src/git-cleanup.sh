#!/bin/bash

if [ -d "./.git" ] ; then
  rm -rf .git/refs/original/
  git reflog expire --expire=now --all
  git gc --prune=now
else
  echo "Not a git repo!"
  exit 1
fi
