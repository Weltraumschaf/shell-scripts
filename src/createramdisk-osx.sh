#!/usr/bin/env bash

##
##
##  Creates a ramdisk and mounts it.
##
##  see: http://hints.macworld.com/article.php?story=20020530084607311
##  see: http://osxdaily.com/2007/03/23/create-a-ram-disk-in-mac-os-x/
##
##

if [ $# -eq 0 ] ; then
	name=ramdisk
	size=512
else
	if [ $# -eq 2 ] ; then
		name=$1
		size=$2
	else
		echo "Creates and mounts a ramdisk."
		echo "Usage: ${0} [name size]"
	fi
fi

echo "Will create ramdisk with name '${name}' and size ${size} MB..."
blocks=`expr $size \* 2048`
diskutil erasevolume HFS+ "${name}" `hdiutil attach -nomount ram://${blocks}`
