#!/bin/bash

cwd=`pwd`

if [ "$1" != "" ]; then
	projectDir=${cwd}/${1}
else
	projectDir=${cwd}
fi


subDirs="bin conf lib reports/coverage tests/lib tests/fixtures tpl"
files=".gitignore build.xml tests/phpunit.xml tests/bootstrap.php"

echo "Generate project ${projectDir}..."
mkdir "${projectDir}"

for dir in ${subDirs}
do
	echo "create dir ${dir}..."
	mkdir -p "${projectDir}/${dirName}"
done

for fileName in ${file}
do
	echo "create file ${file}..."
	touch "${projectDir}/${file}"
done

echo "done."