#!/usr/bin/env bash
set -e
set -o pipefail

STRONG_MSG='\033[1;34m'  # Bold blue
MSG='\033[0;36m'     # Normal cyan
NC='\033[0m'             # No Color

this_script="$0"
root_dir="$(pwd)"
frontend_list_file="$root_dir/frontends.lst"

command="$1"
command_args="${@:2}"
echo -e -n "${STRONG_MSG}Will call ${MSG}${command} \${frontend_name} ${command_args}"
echo -e    "${STRONG_MSG}for each frontend.${NC}"

while read -r line; do

    # Skip lines that are blank or that start with '#'.
    if [[ -z "$line" ]] || [[ "$line" =~ \#.* ]]; then
        continue
    fi

    frontend_name="$line"
    to_run="${command} ${frontend_name} ${command_args}"
    echo -e "${STRONG_MSG}${this_script}:${MSG} ${to_run}${NC}"
    $to_run

done < "$frontend_list_file"
