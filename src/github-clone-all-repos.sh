#!/usr/bin/env bash

set -e
set -u

#
# Clone all my GitHub repos at current working direcotry.
#
# Based on https://gist.github.com/milanboers/f34cdfc3e1ad9ba02ee8e44dae8e093f
#

# | grep \"clone_url\" | awk '{print $2}' | sed -e 's/"//g' -e 's/,//g' | xargs -n1 git clone

curl -s https://api.github.com/users/Weltraumschaf/repos?per_page=200 \
    | jq -r ".[].ssh_url" \
    |  xargs -L1 -P 4 git clone
