#!/usr/bin/env bash

set -e

echo "Making backup..."

backupDir="/media/sven.strittmatter/Backup/"

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
sourceDir="/home/ICONGMBH.DE/sven.strittmatter"

echo "Back up home dir ${sourceDir} to ${backupFileName}..."

tar cvpSf "${backupFileName}" \
  --one-file-system \
  --use-compress-program=pbzip2 \
  --exclude="${sourceDir}/.cache" \
  --exclude="${sourceDir}/.ccache" \
  --exclude="${sourceDir}/Dropbox" \
  --exclude="${sourceDir}/.dropbox" \
  --exclude="${sourceDir}/.Skype" \
  --exclude="${sourceDir}/.local/share/Trash" \
  --exclude="${sourceDir}/.m2/repository" \
  --exclude="${sourceDir}/log" \
  "${sourceDir}"

echo "Done :)"
