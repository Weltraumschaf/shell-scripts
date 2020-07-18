#!/usr/bin/env bash

set -eu

base_dir="/mnt/zstorage/backups/legacy/"

rsync -avzh --no-perms --delete -e 'ssh -p 4222' \
    sxs@johan.weltraumschaf.de:/home/sxs/public_html \
    "${base_dir}"

chown -R sxs:sxs "${base_dir}/public_html"
