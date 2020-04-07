#!/usr/bin/env bash
. dist-pipeline/include.sh

repo_dir="$(pwd)/repos/${repo_name}"
echo -e "${MSG}Installing NPM packages for ${repo_dir}...${NC}" >&2
set -x
cd "$repo_dir"
rm -f package-lock.json
rm -rf node_modules
npm install
set +x
