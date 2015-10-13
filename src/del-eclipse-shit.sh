#!/usr/bin/env bash

CWD=`pwd`

echo "Cleaning ${CWD} from eclipse crap files..."

find "${CWD}" -type d -name "target" | xargs rm -rfv
find "${CWD}" -type d -name "\.settings" | xargs rm -rfv
find "${CWD}" -type f -name "\.project" | xargs rm -v
find "${CWD}" -type f -name "\.classpath" | xargs rm -v
find "${CWD}" -type f -name "MANIFEST.MF" | xargs rm -v
