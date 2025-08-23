#!/usr/bin/env bash

set -euo pipefail

cat <<- 'SCRIPT'
#!/usr/bin/env bash

set -euo pipefail

# @see: http://wiki.bash-hackers.org/syntax/shellvars
[ -z "${SCRIPT_DIRECTORY:-}" ] \
    && SCRIPT_DIRECTORY="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

USAGE="$(basename "${0}")"
HELP=$(cat <<- "EOT"
This script ....

Required options:

    -d|--directory <dir>    The directory where...

Optional options:

    -h|--help         Show this help.
EOT
)
SCRIPT