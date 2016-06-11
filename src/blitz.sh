#!/usr/bin/env bash

now=$(date +%Y-%m-%dT%H-%M-%S)
targetDir="${HOME}/.blitz"

if [ ! -d "${targetDir}" ] ; then
    mkdir -p "${targetDir}"
fi

for i in {1..3} ; do
    targetFile="${targetDir}/${now}_${i}.png"
    imagesnap -w 0.7 "${targetFile}" 
done