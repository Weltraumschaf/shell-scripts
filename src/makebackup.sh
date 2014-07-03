#!/bin/bash

set -e

echo "Making backup..."

backupDir="/media/Backup"

if [ ! -d "${backupDir}"]; then
  echo "Target directory '${backupDir}' not mounted!"
  exit 1
fi

# %F  full date; same as %Y-%m-%d
# %H  hour (00..23)
# %M  minute (00..59)
# %S  second (00..60)
now="$(date +%F_%H-%M-%S)"
backupFileName="${backupDir}/backup_homedir_${now}.tar.bz2"
sourceDir="/home/Sven.Strittmatter"

echo "Back up home dir ${sourceDir} to ${backupFileName}..."

tar cvpSf "${backupFileName}" \
  --one-file-system \
  --use-compress-program=pbzip2 \
  --exclude="${sourceDir}/.cache" \
  --exclude="${sourceDir}/Dropbox" \
  --exclude="${sourceDir}/.dropbox" \
  --exclude="${sourceDir}/.Skype" \
  --exclude="${sourceDir}/.java" \
  --exclude="*.class" \
  --exclude="${sourceDir}/.local/share/Trash" \
  --exclude="${sourceDir}/.m2/repository" \
  "${sourceDir}"

echo "Done :)"
