#!/usr/bin/env bash

set -eu

# Performs a LastPass login.
# $1: The user to login
lastpass_login() {
    lpass login --color=never "${1:-}"
}

# Performs a LastPass logout.
lastpass_logout() {
    lpass logout --color=never -f
}

# Reqeusts password from LastPass for givne ID.
# $1: The ID of the requested password entry
lastpass_export() {
    lpass export --sync=now --color=never
}

now="$(date +%FT%H-%M-%S)"
plain_file="lastpass-backup-${now}.csv"

cleanup() {
    echo "Cleaning up..."
    lastpass_logout
    rm -rf "${plain_file}"
}

# Cleanup stuff on normal exit and interuption.
trap cleanup EXIT
trap cleanup INT

read -rp "User for LastPass: " lastpass_user
lastpass_login "${lastpass_user}"
lastpass_export > "${plain_file}"
encrypt "${plain_file}"
