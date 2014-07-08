#!/bin/bash

##
## Installs a list of my prefered brew tools.
##
## Install:
## ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"
##
## http://mxcl.github.com/homebrew/
##

formulas="coreutils aircrack-ng arping git htop jed john imagemagick nmap maven pwgen rhino scala svn tree unrar wget"

for formula in $formulas ; do
    brew install $formula
done

brew install wireshark --with-qt