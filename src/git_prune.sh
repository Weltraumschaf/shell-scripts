#!/bin/bash

git reflog expire --expire=now --all
git gc --prune=now
