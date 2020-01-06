#!/bin/sh

set -e
set -u

#
# Backscritp for my FreeNAA baes on https://www.ixsystems.com/community/threads/zfs-send-to-external-backup-drive.17850/
#

ALLOWED_CMDS="init|backup"
USAGE="$(basename "$0") ALLOWED_CMDS <source> <target>"

init() {
    echo "init"
    # zfs snapshot -r zstorage@backup
    # zfs send -R zstorage@backup | zfs receive -vF backup
}

backup() {
    echo "backup"
    # zfs rename -r zstorage@backup zstorage@previous_backup
    # zfs snapshot zstorage@backup
    # zfs send -Ri zstorage@previous_backup zstorage@backup | zfs receive -v backup
    # zfs destroy -r zstorage@previous_backup
}

CMD="${1:-}"

case "${CMD}" in
    init) init ;;
    backup) backup ;;
    *)
        if [ "" = "${CMD}" ]; then
            echo "No command given! Use on of: ${ALLOWED_CMDS}" | sed -e 's/|/, /g'
            echo "${USAGE}"
            exit 1
        else
            echo "Unnown command '${CMD}' given! Use on of: ${ALLOWED_CMDS}" | sed -e 's/|/, /g'
            echo "${USAGE}"
            exit 2
        fi
esac