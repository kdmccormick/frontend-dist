#!/usr/bin/env bash
. dist-pipeline/include.sh

repo_dir="$(pwd)/repos/frontend-app-${frontend_name}"
echo -e "${MSG}Running 'npm install' in ${repo_dir}...${NC}" >&2
cd "$repo_dir"
npm install
