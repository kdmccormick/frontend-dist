#!/usr/bin/env bash
set -e
set -o pipefail

MSG='\033[0;32m'  # Green
NC='\033[0m'      # No Color

REPO_NAME_PREFIX=frontend-app-
PROD_CONFIG=webpack.prod.config.js
PUBLIC_ROOT=/var/www/html

root_dir=$(pwd)
repos_dir="$root_dir/repos"
dists_dir="$root_dir/dist"

frontend_name="$1"
repo_name="${REPO_NAME_PREFIX}${frontend_name}"
repo_dir="$repos_dir/$repo_name"
echo -e "${MSG}Running 'npm install' in ${repo_dir}...${NC}"
cd "$repo_dir"
npm install

public_path=$PUBLIC_ROOT/$frontend_name
webpack_command="$(npm bin)/webpack --config '${PROD_CONFIG}' --output-public-path '${public_path}'"
echo -e "${MSG}Running webpack: ${webpack_command}${NC}"
$webpack_command

src_dist_dir="$repo_dir/dist"
dst_dist_dir="$dists_dir/$frontend_name"
echo -e "${MSG}Copying contents of ${src_dist_dir}/ to ${dst_dist_dir}/${NC}"
mkdir -p "$dst_dist_dir"
cp -r "$src_dist_dir"/* "$dst_dist_dir"/

report_file="$dst_dist_dir/report.html"
echo -e "${MSG}Removing ${report_file}; original report still available in repo."
rm -f "$report_file"
