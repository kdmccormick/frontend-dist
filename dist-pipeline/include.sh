#!/usr/bin/env bash
set -e
set -o pipefail
. ./env
frontend_name="$FRONTEND"

MSG='\033[0;32m'  # Green
ERR='\033[0;31m'  # Red
NC='\033[0m'      # No Color

msgbold='\033[1;32m'  # Green

if [[ -z "$frontend_name" ]]; then
	echo -e "${ERR}Environtment variable FRONTEND must be set. Exiting.${NC}" >&2
	exit 123
else
	echo -e "${msgbold}Running '$0' for FRONTEND=$frontend_name${NC}" >&2
fi
