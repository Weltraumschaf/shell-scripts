#!/bin/sh

set -e
set -u

#
# Backup script for my FreeNAS based on https://www.ixsystems.com/community/threads/zfs-send-to-external-backup-drive.17850/
#

ALLOWED_COMMANDS="init|backup|help|test|untest"
USAGE="$(basename "$0") ${ALLOWED_COMMANDS} <source-pool> <target-pool>"

initialize_backup() {
    SOURCE="${1:-}"

    if [ "${SOURCE}" = "" ]; then
        echo "No source given!"
        show_usage
        exit 3
    fi

    TARGET="${2:-}"

    if [ "${TARGET}" = "" ]; then
        echo "No target given!"
        show_usage
        exit 4
    fi

    echo "Initialize backup from ${SOURCE} to ${TARGET}."
    zfs snapshot -r "${SOURCE}@backup"
    zfs send -R "${SOURCE}@backup" | sudo zfs receive -vF "${TARGET}"
}

incremental_backup() {
    SOURCE="${1:-}"

    if [ "${SOURCE}" = "" ]; then
        echo "No source given!"
        show_usage
        exit 3
    fi

    TARGET="${2:-}"

    if [ "${TARGET}" = "" ]; then
        echo "No target given!"
        show_usage
        exit 4
    fi

    echo "Incremental backup from ${SOURCE} to ${TARGET}."
    zfs rename -r "${SOURCE}@backup" "${SOURCE}@previous_backup"
    zfs snapshot "${SOURCE}@backup"
    zfs send -Ri "${SOURCE}@previous_backup" "${SOURCE}@backup" | sudo zfs receive -v "${TARGET}"
    zfs destroy -r "${SOURCE}@previous_backup"
}

SOURCE_POOL_FILE="$(pwd)/source.img"
TARGET_POOL_FILE="$(pwd)/target.img"
SOURCE_POOL_NAME="source"
TARGET_POOL_NAME="target"

create_test_pools() {
    create_test_pool "${SOURCE_POOL_FILE}" "${SOURCE_POOL_NAME}"
    create_test_pool "${TARGET_POOL_FILE}" "${TARGET_POOL_NAME}"
}

create_test_pool() {
    POOL_FILE="${1:-}"
    POOL_NAME="${2:-}"

    echo "Create test pool ${POOL_NAME} in ${POOL_FILE}"
    truncate --size 10G "${POOL_FILE}"
    sudo zpool create -f -O compression=lz4 -O normalization=formD "${POOL_NAME}" "${POOL_FILE}"
    sudo zfs set com.apple.ignoreowner=on "${POOL_NAME}"
}

destroy_test_pools() {
    destroy_test_pool "${SOURCE_POOL_FILE}" "${SOURCE_POOL_NAME}"
    destroy_test_pool "${TARGET_POOL_FILE}" "${TARGET_POOL_NAME}"
}

destroy_test_pool() {
    POOL_FILE="${1:-}"
    POOL_NAME="${2:-}"

    echo "Destroy test pool ${POOL_NAME} in ${POOL_FILE}"
    sudo zfs destroy -r "${POOL_NAME}"
    sudo zpool destroy "${POOL_NAME}"
    rm -rf "${POOL_FILE}"
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
