#!/usr/bin/env bash

set -eu

rsync -avzh --no-perms --delete -e 'ssh -p 4222' sxs@johan.weltraumschaf.de:/home/sxs/public_html /mnt/zstorage/backups/legacy
chown -R sxs:sxs /mnt/zstorage/backups/legacy
