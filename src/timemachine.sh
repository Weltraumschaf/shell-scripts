#!/usr/bin/env bash

# http://blog.interlinked.org/tutorials/rsync_time_machine.html

set -e

baseDir="/media/Backup/Timemachine"

if [ ! -d "${baseDir}" ] ; then
  echo "Target dir '${baseDir}' does not exists!"
  exit 1
fi

date=`date "+%Y-%m-%dT%H:%M:%S"`
current="${baseDir}/current"
backup="${baseDir}/${date}"

rsync -av --delete --one-file-system --partial \
  --exclude='.cache' \
  --exclude='Dropbox' \
  --exclude='.dropbox' \
  --exclude='.Skype' \
  --exclude='.java' \
  --exclude='*.class' \
  --exclude='.local/share/Trash' \
  --exclude='.m2/repository' \
  --link-dest="${current}" "${HOME}" "${backup}"

rm -fv "${current}"
ln -sv "${backup}" "${current}"

echo "Done."
