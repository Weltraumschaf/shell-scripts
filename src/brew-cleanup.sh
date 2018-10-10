#!/usr/bin/env bash

brew cleanup -s
rm -rf "$(brew --cache)"
