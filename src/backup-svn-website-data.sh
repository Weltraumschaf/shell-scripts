#!/usr/bin/env bash

set -eu

base_dir="/mnt/zstorage/backups/legacy/"

rsync -avzh --no-perms --delete -e 'ssh -p 4222' \
    sxs@johan.weltraumschaf.de:/var/svn \
    "${base_dir}"

chown -R sxs:sxs "${base_dir}/svn"

if [ -e "${base_dir}/svn.tgz" ]; then
    rm -v "${base_dir}/svn.tgz"
fi

tar czvf "${base_dir}/svn.tgz" "${base_dir}/svn"
