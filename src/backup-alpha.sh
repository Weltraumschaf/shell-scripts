#!/bin/sh

set -e
set -u

#
# Backscritp for my FreeNAA baes on https://www.ixsystems.com/community/threads/zfs-send-to-external-backup-drive.17850/
#

ALLOWED_COMMANDS="init|backup|help"
USAGE="$(basename "$0") ${ALLOWED_COMMANDS} <source-pool> <target-pool>"

initialize_backup() {
    echo "init"
    # zfs snapshot -r zstorage@backup
    # zfs send -R zstorage@backup | zfs receive -vF backup
}

incremental_backup() {
    echo "backup"
    # zfs rename -r zstorage@backup zstorage@previous_backup
    # zfs snapshot zstorage@backup
    # zfs send -Ri zstorage@previous_backup zstorage@backup | zfs receive -v backup
    # zfs destroy -r zstorage@previous_backup
}

show_usage() {
    echo "Usage: ${USAGE}"
}

show_help () {
    echo "This script backups a ZFS pool via send and receive to a target pool."
    echo
    show_usage
    echo
    echo "  init      Does the initial backup. This may take a while."
    echo "  backup    Does an incremental backup."
    echo "  help      Show this help."
    echo
}

COMMAND="${1:-}"
SOURCE_POOL="${2:-}"
TARGET_POOL="${3:-}"

case "${COMMAND}" in
    init)
        initialize_backup "${SOURCE_POOL}" "${TARGET_POOL}"
        ;;
    backup)
        incremental_backup "${SOURCE_POOL}" "${TARGET_POOL}"
        ;;
    help)
        show_help
        ;;
    *)
        if [ "" = "${COMMAND}" ]; then
            echo "Error: No command given! Use on of: ${ALLOWED_COMMANDS}" | sed -e 's/|/, /g'
            show_usage
            echo
            exit 1
        else
            echo "Error: Unnown command '${COMMAND}' given! Use on of: ${ALLOWED_COMMANDS}" | sed -e 's/|/, /g'
            show_usage
            echo
            exit 2
        fi
esac