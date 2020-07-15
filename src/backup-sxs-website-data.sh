#!/usr/bin/env bash

set -eu

rsync -avzh root@johan.weltraumschaf.de:/var/svn /mnt/zstorage/backups/legacy
chown -R sxs:sxs /mnt/zstorage/backups/legacy
