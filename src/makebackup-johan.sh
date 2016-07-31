#!/bin/bash

today="$(date +%Y-%m-%d)"

if [ ! -e ./makebackup-johan.config ] ; then
    echo "No config file present: makebackup-johan.config"
    exit 1
fi

source ./makebackup-johan.config

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
scp -P${backupPort} \
    "./${backupFileName}" \
    "${backupUser}@${backupHost}:${backupTargetDir}"

echo "Removing ${backupDir} ${backupFileName} ..."
rm -rfv "./${backupBaseDir}"
rm -rfv "./${backupFileName}"

echo "Done :-)"
