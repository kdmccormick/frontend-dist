#!/usr/bin/env bash
set -e
set -o pipefail
. ./env
frontend_name="$FRONTEND_NAME"

MSG='\033[0;32m'  # Green
ERR='\033[0;31m'  # Red
NC='\033[0m'      # No Color

echo -e "\033[1;32mRunning '$0' for FRONTEND_NAME=$FRONTEND_NAME"
