#!/usr/bin/env bash
set -e
set -o pipefail
. ./env

MSG='\033[0;32m'  # Green
WARN='\033[0;33m'  # Yellow
ERR='\033[0;31m'  # Red
NC='\033[0m'      # No Color

msgbold='\033[1;32m'  # Green

if [[ ! -z "$FRONTEND" ]] ; then
	echo -e "${msgbold}Running '$0' for FRONTEND=$FRONTEND${NC}" >&2
elif [[ ! -z "$REPO" ]] ; then
	echo -e "${msgbold}Running '$0' for REPO=$REPO${NC}" >&2
else
	echo -e "${ERR}Environtment variable FRONTEND or REPO must be set. Exiting.${NC}" >&2
	exit 123
fi
frontend_name="$FRONTEND"
repo_name=${REPO:-frontend-app-${frontend_name}}

set -u
