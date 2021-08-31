#!/usr/bin/env bash

#
# Morning script to start a work day
#

set -euo pipefail

if [[ "$OSTYPE" != "darwin"* ]]; then
    echo "This script is only for macOS!"
    exit 1
fi

declare -a apps=(
    "BusyCal.app"
    "Discord.app"
    "Fork.app"
    "Joplin.app"
    "Mail.app"
    "Microsoft Teams.app"
    "MultiFirefox.app"
    "NetNewsWire.app"
    "Slack.app"
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
    open -a "${app}"
done

echo "Everything startet!"

cat <<- "EOT"

    Morning Todos
    -------------

    * topgrade
    * Jira
    * DevOps Team
    * SECKT
    * GitHub
    * Notifications
    * Projectboard
    * Trello
    * SCB Retromaßnahmen

EOT

ultralist list