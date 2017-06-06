#!/bin/sh

# https://gist.github.com/jaibeee/9a4ea6aa9d428bc77925

# Configure homebrew permissions to allow multiple users on MAC OSX.
# Any user from the admin group will be able to manage the homebrew and cask installation on the machine.

# allow admins to manage homebrew's local install directory
chgrp -R admin /usr/local
chmod -R g+w /usr/local
chmod -R a+rX /usr/local
chmod a+x /usr/local/bin

# allow admins to homebrew's local cache of formulae and source files
if [ -d /Library/Caches/Homebrew ]; then
  chgrp -R admin /Library/Caches/Homebrew
  chmod -R g+w /Library/Caches/Homebrew
fi

# if you are using cask then allow admins to manager cask install too
if [ -d /opt/homebrew-cask ]; then
  chgrp -R admin /opt/homebrew-cask
  chmod -R g+w /opt/homebrew-cask
fi

echo "Finished :)"