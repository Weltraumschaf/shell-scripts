#!/bin/bash

##
## Short hand to stop mysqld on Mac OS.
##

sudo launchctl unload -w /Library/LaunchDaemons/com.mysql.mysqld.plist
