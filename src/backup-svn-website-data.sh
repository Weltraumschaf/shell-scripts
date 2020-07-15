#!/usr/bin/env bash

set -eu

rsync -avzh -e 'ssh -p 4222' root@johan.weltraumschaf.de:/var/svn /mnt/zstorage/backups/legacy
chown -R sxs:sxs /mnt/zstorage/backups/legacy
