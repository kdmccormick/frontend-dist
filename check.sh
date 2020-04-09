#!/usr/bin/env bash
. dist-pipeline/include.sh

SUCCESS='\033[0;32m'  # Green
NC='\033[0m'          # No Color

set -x
curl --fail http://localhost:"$DOCKER_HOST_PORT"/"$frontend_name"/ 1>/dev/null
set +x
echo -e "${SUCCESS}HTTP 2XX from index of ${frontend_name}; check complete.${NC}"
