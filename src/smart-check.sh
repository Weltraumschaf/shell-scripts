#!/bin/sh

if [ "" = "${SMART_DEVICES}" ] ; then
    echo "Export variable SMART_DEVICES with devices in /dev to check!"
    echo "Use 'smartctl --scan' to find them."
    exit 1
fi

for dev in ${SMART_DEVICES} ; do
    smartctl -t long /dev/${dev}
done
