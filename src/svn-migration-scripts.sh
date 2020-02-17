#!/usr/bin/env bash

set -e 

# https://www.atlassian.com/git/tutorials/svn-to-git-prepping-your-team-migration

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

if [ -z "${BFG_DIR}" ] ; then
    BFG_DIR=`cd "${PROGRAM_DIRECTORY}" ; pwd`
fi

JAR="${BFG_DIR}/svn-migration-scripts.jar"

if [ ! -f "${JAR}" ] ; then
    PROJECT_DIR=`dirname "${BFG_DIR}"`
    echo "ERROR: JAR file ${JAR} not pressent in ${BFG_DIR}!"
    exit 1
fi

java ${JVM_OPTIONS} -jar "${JAR}" $@
