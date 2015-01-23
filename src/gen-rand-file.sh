#!/bin/bash

FILENAME=${1}
SIZE_IN_MB=${2}

count=$((1024 * $SIZE_IN_MB))
dd if=/dev/urandom of=${FILENAME} bs=1024 count=$count