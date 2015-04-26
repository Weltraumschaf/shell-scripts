#!/usr/bin/env bash

# To restore
# sudo dpkg --set-selections < /tmp/dpkglist.txt
# sudo apt-get -y update
# sudo apt-get dselect-upgrade

# %F  full date; same as %Y-%m-%d
# %H  hour (00..23)
# %M  minute (00..59)
# %S  second (00..60)
now="$(date +%F_%H-%M-%S)"
filename="${now}_dpkglist.txt"

echo "Backing up installed packages ..."

dpkg --get-selections > "${filename}"
bzip2 "${filename}"
