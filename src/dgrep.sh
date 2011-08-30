#!/bin/sh

exec pcregrep -r --exclude='/_darcs|/tmp|\.swp|\.cache|\.o$|\.[tT][tT][fF]$|\.jpg$|\.png$|\.gif$|\.swf$|\.pdf$|\-darcs\-backup' "$@" $PWD
