#!/usr/bin/env bash

set -e
set -u

usage="Usage: ${0} <input-file> <output-dir>"
example="Example: ${0} src/main/resources/services.properties OSGI-INF"

function help {
    echo "${usage}"
    echo "${example}"
}

inputFile="${1-}"
if [ "${inputFile}" == "" ]; then
    echo "No input file given!"
    echo
    help
    exit 1
fi

outputDir="${2-}"

if [ "${outputDir}" == "" ]; then
    echo "No output dir given!"
    echo
    help
    exit 2
fi

if [ ! -e "${outputDir}" ]; then
    mkdir -pv "${outputDir}"
fi

if [ ! -d "${outputDir}" ]; then
    echo "${outputDir} is not a direcotry!"
    exit 3
fi

cat "${inputFile}" | while read line; do
    interface=$(echo "${line}" | cut -d '=' -f 1)
    implementation=$(echo "${line}" | cut -d '=' -f 2)
    xmlFile="${outputDir}/${interface}.xml"
    
    echo '<?xml version="1.0" encoding="UTF-8"?>' > "${xmlFile}"
    echo "<scr:component xmlns:scr=\"http://www.osgi.org/xmlns/scr/v1.1.0\" name=\"${implementation}\">" >>  "${xmlFile}"
    echo "   <implementation class=\"${implementation}\"/>" >>  "${xmlFile}"
    echo '   <service>' >>  "${xmlFile}"
    echo "      <provide interface=\"${interface}\"/>" >>  "${xmlFile}"
    echo '   </service>' >>  "${xmlFile}"
    echo '</scr:component>' >>  "${xmlFile}"
done 

echo 'Done :-)'