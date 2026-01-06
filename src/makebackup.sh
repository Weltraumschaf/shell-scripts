#!/usr/bin/env bash

set -e

echo "Making backup..."

backupDir="/mnt/Backup/"
sourceDir="/home/sxs"

if [ ! -d "${backupDir}" ]; then
  echo "Target directory '${backupDir}' not mounted!"
  exit 1
fi

# %F  full date; same as %Y-%m-%d
# %H  hour (00..23)
# %M  minute (00..59)
# %S  second (00..60)
now="$(date +%F_%H-%M-%S)"
backupFileName="${backupDir}/backup_homedir_${now}.tar.bz2"

echo "Back up home dir ${sourceDir} to ${backupFileName}..."

tar cvpSf "${backupFileName}" \
  --one-file-system \
  --use-compress-program=pbzip2 \
  --exclude="${sourceDir}/.cache" \
  --exclude="${sourceDir}/.ccache" \
  --exclude="${sourceDir}/Nextcloud" \
  --exclude="${sourceDir}/.local/share/Trash" \
  --exclude="${sourceDir}/.m2/repository" \
  --exclude="${sourceDir}/log" \
  "${sourceDir}"

echo "Done :)"
