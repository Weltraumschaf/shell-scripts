#!/usr/bin/env bash

brew cleanup --force -s
rm -rf "$(brew --cache)"
