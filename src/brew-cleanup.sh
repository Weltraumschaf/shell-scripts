#!/bin/bash

brew cleanup --force -s
rm -rf $(brew --cache)
