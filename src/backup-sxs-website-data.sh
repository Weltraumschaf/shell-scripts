#!/usr/bin/env bash

set -eu

base_dir="/mnt/zstorage/backups/legacy/"

rsync -avh -zz --no-perms --delete -e 'ssh -p 4222' \
    wesley@tpol.weltraumschaf.de:/var/www/sxs.weltraumschaf.de \
    "${base_dir}"

chown -R sxs:sxs "${base_dir}/sxs.weltraumschaf.de"
