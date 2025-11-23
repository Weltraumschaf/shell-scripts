#!/usr/bin/env bash

#
# Hello script to start a work on my machine.
#

set -euo pipefail

if [[ "$OSTYPE" != "darwin"* ]]; then
    echo "This script is only for macOS!"
    exit 1
fi

declare -a apps=(
    "Bitwarden.app"
    "BusyCal.app"
    "ChatGPT.app"
    "Claude.app"
    "DeepL.app"
    "Discord.app"
    "Element.app"
    "Fork.app"
    "Ice Cubes.app"
    "Joplin.app"
    "MultiFirefox.app"
    "NetNewsWire.app"
    "Perplexity.app"
    "Signal.app"
    "TextMate.app"
    "Thunderbird.app"
    "Trello.app"
)

cat <<- "EOT"

    ____                 _                              _             _
   / ___| ___   ___   __| |  _ __ ___   ___  _ __ _ __ (_)_ __   __ _| |
  | |  _ / _ \ / _ \ / _` | | '_ ` _ \ / _ \| '__| '_ \| | '_ \ / _` | |
  | |_| | (_) | (_) | (_| | | | | | | | (_) | |  | | | | | | | | (_| |_|
   \____|\___/ \___/ \__,_| |_| |_| |_|\___/|_|  |_| |_|_|_| |_|\__, (_)
                                                                |___/

EOT

echo "Starting some apps..."

for app in "${apps[@]}"; do
    echo -n '.'
    open -a "${app}" || true
done
echo

echo "Everything startet!"

cat <<- "EOT"

    Nice Tools 🤓
    -------------

    * cheat
    * worm-whole

EOT
