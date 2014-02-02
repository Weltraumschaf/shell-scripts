#!/bin/sh

# https://apple.stackexchange.com/questions/82807/how-to-cleanly-remove-homebrew

cd `brew --prefix`
rm -rf Cellar
rm `git ls-files`
brew prune
rm -r Library/Homebrew Library/Aliases Library/Formula Library/Contributions
rm -rf .git
rm -rf ~/Library/Caches/Homebrew
