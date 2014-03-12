#!/bin/bash

# http://www.upubuntu.com/2011/09/how-to-free-up-ram-on-ubuntudebian.html

free -mh

echo "Free RAM..."
sync
su
echo 3 > /proc/sys/vm/drop_caches

free -mh
