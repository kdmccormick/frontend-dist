#!/usr/bin/env bash
set -e
set -u
set -o pipefail
set -x

host_redirects="$1"
config_template="$2"
to_inject=""

while read -r line; do

	trimmed=$(echo "$line" | xargs)

    # Skip lines that are blank or that start with '#'.
    if [[ -z "$trimmed" ]] || [[ "$trimmed" =~ \#.* ]]; then
        continue
    fi

    frontend=$(echo "$trimmed" | cut -f1 -d" ")
    port=$(echo "$trimmed" | cut -f2 -d" ")
    to_inject=$( \
    	echo "$to_inject" ; \
    	echo "    rewrite ^/${frontend}(/(.*))?\$ http://localhost:${port}/\$2 redirect;" \
    )

done < "$host_redirects"

IFS=''  # Preserve leading whitespace in nesxt loop.
while read -r line; do
    if [[ "$line" == *"#HOST_FRONTEND_REDIRECTS"* ]]; then
        echo "$to_inject"
    else
    	echo "$line"
    fi
done < "$config_template"

