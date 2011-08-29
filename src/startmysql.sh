#!/bin/bash

##
## Short hand to start mysqld on Mac OS.
##

sudo launchctl load -w /Library/LaunchDaemons/com.mysql.mysqld.plist
