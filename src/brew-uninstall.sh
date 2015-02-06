#!/bin/sh

# https://apple.stackexchange.com/questions/82807/how-to-cleanly-remove-homebrew

cd `brew --prefix`
rm -rf Cellar
brew prune
for f in  $(git ls-files); do rm -v "${f}"; done
rm -rf  Library/Homebrew
rm -rf .git
rm -rf ~/Library/Caches/Homebrew
