#!/bin/sh

set -e
set -u

#
# Backscritp for my FreeNAA baes on https://www.ixsystems.com/community/threads/zfs-send-to-external-backup-drive.17850/
#

ALLOWED_COMMANDS="init|backup|help|test|untest"
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

SOURCE_POOL_FILE="$(pwd)/source.img"
TARGET_POOL_FILE="$(pwd)/target.img"
SOURCE_POOL_NAME="source"
TARGET_POOL_NAME="target"

create_test_pools() {
    truncate --size 10G "${SOURCE_POOL_FILE}" "${TARGET_POOL_FILE}"
    ZPOOL_CREATE_OPTIONS="-f -O compression=lz4 -O normalization=formD"
    # shellcheck disable=SC2086
    sudo zpool create ${ZPOOL_CREATE_OPTIONS} "${SOURCE_POOL_NAME}" "${SOURCE_POOL_FILE}"
    # shellcheck disable=SC2086
    sudo zpool create ${ZPOOL_CREATE_OPTIONS} "${TARGET_POOL_NAME}" "${TARGET_POOL_FILE}"
}

destroy_test_pools() {
    sudo zfs destroy -r "${SOURCE_POOL_NAME}"
    sudo zpool destroy "${SOURCE_POOL_NAME}"
    sudo zfs destroy -r "${TARGET_POOL_NAME}"
    sudo zpool destroy "${TARGET_POOL_NAME}"
    rm -rf "${SOURCE_POOL_FILE}" "${TARGET_POOL_FILE}"
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
    echo "  test      Creates two test pools (source and target) with 10 GB sparse files in current working direcotry."
    echo "  untest    Destroys the test pools and delets the sparse image files."
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
    test)
        create_test_pools
        ;;
    untest)
        destroy_test_pools
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