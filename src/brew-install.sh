#!/usr/bin/env bash

##
## Installs a list of my prefered brew tools.
##
## Install:
## ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"
##
## http://mxcl.github.com/homebrew/
##

formulas="ant coreutils aircrack-ng arping git htop jed john imagemagick nmap maven pwgen rhino scala svn tree tmux unrar wget"
casks="vlc iterm2"

for formula in $formulas; do
    brew install "${formula}"
done

for cask in $casks; do
    brew cask install "${cask}"
done

brew install wireshark --with-qt
