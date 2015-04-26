#!/usr/bin/env bash

exec pcregrep -r --exclude='/\.git|/_darcs|\/tmp|\.swp|\.cache|\.o$|\.[tT][tT][fF]$|\.jpg$|\.png$|\.gif$|\.swf$|\.pdf$|\-darcs\-backup' "$@" $PWD
