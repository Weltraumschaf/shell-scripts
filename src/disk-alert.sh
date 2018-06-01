#!/usr/bin/env bash

# http://www.linuxjournal.com/content/tech-tip-send-email-alert-when-your-disk-space-gets-low

RECIPIENTS="ich@weltraumschaf.de"

THRESHOLD=90
HOST=$(hostname)

DISK_INFO=$(df -h / | grep /)
CURRENT=$(echo "${DISK_INFO}" | awk '{ print $5}' | sed 's/%//g')
SIZE=$(echo "${DISK_INFO}" | awk '{ print $2}')
USED=$(echo "${DISK_INFO}" | awk '{ print $3}')
AVAIL=$(echo "${DISK_INFO}" | awk '{ print $4}')
DEVICE=$(echo "${DISK_INFO}" | awk '{ print $1}')

if [ "${CURRENT}" -gt "${THRESHOLD}" ] ; then
    /usr/sbin/ssmtp ${RECIPIENTS} << EOF
Subject: Disk Space Alert (${HOST}.iteratec.de)
To: ${RECIPIENTS}
From: iteratec-noreply@iteratec.de

Your root partition remaining free space is critically (threshold: ${THRESHOLD})!

Device:    ${DEVICE}
Size:      ${SIZE}
Used:      ${USED} (${CURRENT} %)
Avail:     ${AVAIL}

EOF
fi