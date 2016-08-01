#!/bin/bash

PROGRAM="${0}"

while [ -h "${PROGRAM}" ]; do
  LS=`ls -ld "${PROGRAM}"`
  LINK=`expr "${LS}" : '.*-> \(.*\)$'`

  if expr "${LINK}" : '.*/.*' > /dev/null; then
    PROGRAM="${LINK}"
  else
    PROGRAM=`dirname "${PROGRAM}"`/"${LINK}"
  fi
done

PROGRAM_DIRECTORY=`dirname "${PROGRAM}"`

today="$(date +%Y-%m-%d)"

if [ ! -e "${PROGRAM_DIRECTORY}/makebackup-johan.config" ] ; then
    echo "No config file present: ${PROGRAM_DIRECTORY}/makebackup-johan.config"
    exit 1
fi

source "${PROGRAM_DIRECTORY}/makebackup-johan.config"

echo "=================================="
echo "== Making backup ${today} ... =="
echo "=================================="

backupBaseDir="backup"
backupDir="/var/data/${backupBaseDir}"
backupFileName="backup_$today.tar"
svnDir=/var/svn

echo "Removing ${backupDir}..."
rm -rfv "${backupDir}"
echo "Creating ${backupDir}..."
mkdir -pv "${backupDir}"
echo "Change into directory ${backupDir}..."
cd "${backupDir}"

mysqlUser=""
mysqlPassword=""

if [ -f "/etc/mysql/debian.cnf" ] && [ -z "$mysqlUser" ]; then
   mysqlUser="$(grep "^user" /etc/mysql/debian.cnf | sed 's@^user[ \t=]*@@' | tail -n 1)"
   mysqlPassword="$(grep "^password" /etc/mysql/debian.cnf | sed 's@^password[ \t=]*@@' | tail -n 1)"
fi

echo "Dumping all mysql databases as ${mysqlUser}..."

if [ -z "$mysqlPassword" ]; then
   echo "No Debian user for MySQL user ${mysqlUser} found!"
   exit 1
fi

# FIXME Produce an error in the file!
mysqldump -u${mysqlUser} -p${mysqlPassword} --all-databases > \
    "all-databases_${today}.sql"
echo "Compressing all-databases_${today}.sql..."
pbzip2 "all-databases_${today}.sql"

echo "Dumping all svn repos..."
svnDumpDir="${backupDir}/svndumps"
mkdir "${svnDumpDir}"

for fileName in $(ls $svnDir) ; do
    echo "Dumping ${svnDir}/${fileName}..."
    svnadmin dump ${svnDir}/${fileName} > ${svnDumpDir}/${fileName}.dump
    echo "Compressing ${svnDumpDir}/${fileName}.dump..."
    pbzip2 ${svnDumpDir}/${fileName}.dump
done

sourceDirs="etc home root var opt"
for sourceDir in $sourceDirs; do
    echo "Backing up /${sourceDir}..."
    tar cvpSf "${sourceDir}.tar.bz2" \
        --one-file-system "/${sourceDir}" \
        --use-compress-program=pbzip2
done

cd ..
echo "Generate ${backupFileName}"
tar cvf "${backupFileName}" "./${backupBaseDir}"

echo "Putting backup to ${backupHost}"
# http://x-ian.net/2009/05/15/resume-rsync-transfer-after-ssh-connection-crash/
I=0
MAX_RESTARTS=5
LAST_EXIT_CODE=1
while [ $I -le $MAX_RESTARTS ] ; do
	I=$(( $I + 1 ))
	echo "$I. start of rsync..."
	rsync -av --partial -e "ssh -p${backupPort} -i ~/.ssh/id_rsa" \
		"./${backupFileName}" \
		"${backupUser}@${backupHost}:${backupTargetDir}"
	LAST_EXIT_CODE=$?
	
	if [ $LAST_EXIT_CODE -eq 0 ]; then
		break
	fi
done

if [ $LAST_EXIT_CODE -ne 0 ]; then
  echo "ERROR: rsync failed for $I times. giving up."
  exit 1
fi

echo "Removing ${backupDir} ${backupFileName} ..."
rm -rfv "./${backupBaseDir}"
rm -rfv "./${backupFileName}"

echo "Done :-)"
