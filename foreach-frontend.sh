#!/usr/bin/env bash
set -e
set -o pipefail

STRONG_MSG='\033[1;34m' # Bold blue
MSG='\033[0;36m'        # Normal cyan
NC='\033[0m'            # No Color

this_script="$0"
root_dir="$(pwd)"
frontend_list_file="$root_dir/frontends.lst"

command="$@"
echo -e -n "${STRONG_MSG}Will call ${MSG}${command} " >&2
echo -e    "${STRONG_MSG}for each frontend.${NC}" >&2

while read -r line; do

    # Skip lines that are blank or that start with '#'.
    if [[ -z "$line" ]] || [[ "$line" =~ \#.* ]]; then
        continue
    fi

    FRONTEND=$line ${command}

done < "$frontend_list_file"
