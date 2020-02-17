#!/usr/bin/env bash
set -e
set -o pipefail
. ./env
frontend_name="$1"

SUCCESS='\033[0;32m'  # Green
NC='\033[0m'          # No Color

curl --fail http://localhost:"$NGINX_HOST_PORT"/"$frontend_name"/ 1>/dev/null
echo -e "${SUCCESS}HTTP 2XX from index of ${frontend_name}; check complete.${NC}"
