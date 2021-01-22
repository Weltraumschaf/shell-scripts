#!/usr/bin/env bash

set -euo pipefail

IMAGE_TO_SCAN="${1:-}"
CWD="$(pwd)"
RESULT_DIR="${CWD}/clair_result"

if [[ -z "${IMAGE_TO_SCAN}" ]]; then
    echo "Error: no image given to scan!"
    echo "Usage: $(basename "${0}") <image>"
    exit 1
fi

if [[ -e "" ]]; then
    rm -rf "${RESULT_DIR}"
fi

mkdir -p "${RESULT_DIR}"
docker run --rm \
    -v "/var/run/docker.sock:/var/run/docker.sock" \
    -v "${RESULT_DIR}:/result" \
    -e PROJECT_NAME="ClairInABox_${RANDOM}" \
    -e IMAGE_TO_SCAN="${IMAGE_TO_SCAN}" \
    iteratec/clairinabox:latest
