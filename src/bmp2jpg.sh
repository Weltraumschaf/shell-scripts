#!/usr/bin/env bash

##
## Script to convert BMP images to JPEF.
##

cwd=`pwd`

for file in "${dir}/*.bmp"
do
	 convert "${file}" "${file%.*}".jpg
done
