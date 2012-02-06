#!/bin/bash

PORTS_HOME="/opt/local"

echo "cleaning MacPorts in ${PORTS_HOME}…"
echo "calculating actual usage…"

USAGE_BEFORE=`du -sh "${PORTS_HOME}"`
echo "current usage: ${USAGE_BEFORE}"

echo cleaning...
port clean --all installed
port -f uninstall inactive

USAGE_AFTER=`du -sh "${PORTS_HOME}"`
echo "finished"
echo "current usage: ${USAGE_BEFORE}"