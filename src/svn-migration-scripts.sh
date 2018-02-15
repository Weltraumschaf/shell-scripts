#!/usr/bin/env bash

# https://www.atlassian.com/git/tutorials/migrating-prepare

set -u
set -e

# JVM settings.
JVM_MIN_HEAP_SPACE="128m"
JVM_MAX_HEAP_SPACE="1024m"
JVM_OPTIONS="-Xms${JVM_MIN_HEAP_SPACE} -Xmx${JVM_MAX_HEAP_SPACE}"

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

if [ -z "${PROGRAM_DIRECTORY}" ] ; then
    PROGRAM_DIRECTORY=`cd "${PROGRAM_DIRECTORY}" ; pwd`
fi

JAR="${PROGRAM_DIRECTORY}/svn-migration-scripts.jar"

if [ ! -f "${JAR}" ] ; then
    echo "ERROR: JAR file ${JAR} not pressent in ${PROGRAM_DIRECTORY}!"
    exit 1
fi

java ${JVM_OPTIONS} -jar "${JAR}" $@
