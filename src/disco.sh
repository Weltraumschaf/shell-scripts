#!/usr/bin/env bash

set -euo pipefail

#
# Make Project Libre "Cloud Ready"
#
# This is macOS only!
#
# This is a wrapper script for ProjectLibre.app (brew install projectlibre) that creates a lock file
# a along side with the opend file to prevent opening it twice. This is done because we wnat to share the
# project in OneDrive.
#
# This is not 100 % safe. There may be soem seconds this implementation is vulnarable on concurrent file
# access. But itis better than nothing to prevent lost updates.
#

USAGE="Usage: $(basename "$0") <path/to/file.pod>"

echo_err() {
    >&2 echo "${1}"
}

acquire_lock() {
    local pod_file_lock
    pod_file_lock="${1}"

    echo "Try to get lock..."

    if [[ -e "${pod_file_lock}" ]]; then
        echo_err "Error: Can't acquire lock! Lock file '${pod_file_lock}' already exists."
        exit 1
    fi

    touch "${pod_file_lock}"
    echo "$USER:$(date)"
    echo "Lock file written: ${pod_file_lock}"
}

release_lock() {
    local pod_file_lock
    pod_file_lock="${1}"

    if [[ -e "${pod_file_lock}" ]]; then
        rm -rf "${pod_file_lock}"
        echo "Lock released."
    else
        echo_err "Warning: Can't release lock! Lock file '${pod_file_lock}' does not exist exists."
    fi
}

open_project_libre() {
    local pod_file
    pod_file="${1}"

    open --wait-apps -a ProjectLibre "${pod_file}"
}

main() {
    if [[ "$#" != "1" ]]; then
        echo_err "Error: Wrong number of arguments! Only one path to .pod file allowed as argument."
        echo_err "$USAGE"
        exit 1
    fi

    local pod_file pod_file_lock
    pod_file="${1}"
    pod_file_lock="${pod_file}.locked"

    acquire_lock "${pod_file_lock}"
    open_project_libre "${pod_file}"
    release_lock "${pod_file_lock}"
}

main "$@"
