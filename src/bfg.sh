#!/bin/bash

##
##  LICENSE
##
## "THE BEER-WARE LICENSE" (Revision 43):
## "Sven Strittmatter" <weltraumschaf@googlemail.com> wrote this file.
## As long as you retain this notice you can do whatever you want with
## this stuff. If we meet some day, and you think this stuff is worth it,
## you can buy me a non alcohol-free beer in return.
##
## Copyright (C) 2012 "Sven Strittmatter" <weltraumschaf@googlemail.com>
##

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

# Set BFG_HOME.
if [ -z "${BFG_HOME}" ] ; then
    BFG_HOME=`cd "${PROGRAM_DIRECTORY}" ; pwd`
fi

JAR="${BFG_HOME}/bfg-1.11.1.jar"

if [ ! -f "${JAR}" ] ; then
    PROJECT_DIR=`dirname "${BFG_HOME}"`
    echo "ERROR: JAR file ${JAR} not pressent!"
    echo "Download here http://repo1.maven.org/maven2/com/madgag/bfg/1.11.1/bfg-1.11.1.jar"
    exit 1
fi

java ${JVM_OPTIONS} -jar "${JAR}" $@
