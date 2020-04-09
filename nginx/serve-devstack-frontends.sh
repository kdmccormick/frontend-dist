#!/usr/bin/env bash
set -e
set -o pipefail
set -u

# Exit upon docker shutdown (15 == SIGTERM)
trap "exit" 15

while true; do
	echo "Generating nginx configuration."
	/edx/app/write-nginx-conf.sh
	echo "Starting nginx."
	set -x
	nginx -g "daemon off;"
	set +x
	echo "nginx killed."
	sleep 1
done
