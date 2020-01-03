#!/usr/bin/env bash

set -e
set -u

#
# Backscritp for my FreeNAA baes on https://www.ixsystems.com/community/threads/zfs-send-to-external-backup-drive.17850/
#

CMD="${1:-}"

if [ "${CMD}" = "init" ]; then
    zfs snapshot -r zstorage@backup
    zfs send -R zstorage@backup | zfs receive -vF backup
else
    zfs rename -r zstorage@backup zstorage@previous_backup
    zfs snapshot zstorage@backup
    zfs send -Ri zstorage@previous_backup zstorage@backup | zfs receive -v backup
    zfs destroy -r zstorage@previous_backup
fi