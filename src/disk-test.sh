#!/usr/bin/env bash

#
# Performs a stress test for a given disk
#

set -euo pipefail

# @see: http://wiki.bash-hackers.org/syntax/shellvars
[ -z "${SCRIPT_DIRECTORY:-}" ] \
    && SCRIPT_DIRECTORY="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

USAGE="Usage: $(basename "$0") -d <dir> [-h|--help]"
HELP=$(cat <<- EOT
This script installs a macOS node.

Required options:

    -d|--directory <dir>    The directory where the written testfiles will be stored.

Optional options:

    -n|--number             The number of files to create for the test.
    -h|--help         Show this help.
EOT
)

DIRECTORY=""
NUMBER="10"
while (( "$#" )); do
  case "${1}" in
    -d|--directory)
      if [ -n "${2}" ] && [ "${2:0:1}" != "-" ]; then
        DIRECTORY="${2}"
        shift 2
      else
        error "Argument for ${1} is missing"
        echo_err "${USAGE}"
        exit 1
      fi
      ;;
    -n|--number)
      if [ -n "${2}" ] && [ "${2:0:1}" != "-" ]; then
        NUMBER="${2}"
        shift 2
      else
        error "Argument for ${1} is missing"
        echo_err "${USAGE}"
        exit 1
      fi
      ;;
    -h|--help)
      print_help
      exit 0
        ;;
    *)
      error "Unsupported option: $1!"
      echo_err "${USAGE}"
      exit 1
      ;;
    esac
done

print_help() {
    echo "${USAGE}"
    echo
    echo "${HELP}"
    echo
}

generate_file() {
  local file_source="/dev/random"
  local dir="${1:-}"
  if [[ -z "${dir}" ]]; then echo "No dir given as first argument!"; return 0; fi

  file_name="${dir}/testfile_${RANDOM}"
  echo "Write file ${i} to ${file_name}..."
  dd if="${file_source}" of="${file_name}" bs=1M count=100 >/dev/null 2>&1
  echo "Read file ${i} to ${file_name}..."
  sha1sum "${file_name}" >/dev/null 2>&1
  echo "Delete file ${i} to ${file_name}..."
  rm "${file_name}"
}

main() {
  local dir="${1:-}"
  if [[ -z "${dir}" ]]; then echo "No directory given!"; print_help; exit 1; fi

  local number_of_files="${2:-}"
  if [[ -z "${number_of_files}" ]]; then echo "No number given as second argument!"; return 0; fi

  echo "Starting test using dir ${dir}"
  for i in $(seq "${number_of_files}"); do
    generate_file "${dir}"
  done
}

main "${DIRECTORY}" "${NUMBER}"
