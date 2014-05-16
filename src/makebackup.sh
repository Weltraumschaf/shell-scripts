#!/bin/bash

set -e

echo "Making backup..."

# %F  full date; same as %Y-%m-%d
# %H  hour (00..23)
# %M  minute (00..59)
# %S  second (00..60)
now="$(date +%F_%H-%M-%S)"
prefix="backup_${now}"

backupDir="/media/Backup"

if [ ! -d "${backupDir}"]; then
  echo "Target directory '${backupDir}' not mounted!"
  exit 1
fi

backupFileName="${prefix}.tar"
tmpDir="${backupDir}/${prefix}"

echo "Creating tmp dir ${tmpDir} ..."
mkdir -p "${tmpDir}"

echo "Change into directory ${tmpDir} ..."
cd "${tmpDir}"

sourceDir="/home/Sven.Strittmatter"
echo "Back up home dir ${sourceDir} ..."
tar cvpSf "Sven.Strittmatter.tar.bz2" \
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

#echo "Backup /etc ..."
#tar cvpSf "etc.tar.bz2" \
#  --use-compress-program=pbzip2 \
#  --one-file-system \
#  "/etc"

echo "Backing up installed packages ..."
# To restore
# sudo dpkg --set-selections < /tmp/dpkglist.txt
# sudo apt-get -y update
# sudo apt-get dselect-upgrade
dpkg --get-selections > dpkglist.txt
bzip2 dpkglist.txt

echo "Create final archive ${backupDir}/${backupFileName} ..."
tar cvf "${backupDir}/${backupFileName}" "${tmpDir}"

echo "Removing tmp dir ${tmpDir} ..."
rm -rvf "${tmpDir}"

echo "Done :)"
