#!/usr/bin/env bash
set -e
set -o pipefail
. ./env
frontend_name="$1"

MSG='\033[0;32m'  # Green
NC='\033[0m'      # No Color

root_dir=$(pwd)
repos_dir="$root_dir/repos"
dists_dir="$root_dir/dist"
docker_frontends_dir="$root_dir/docker/frontends"

repo_name="frontend-app-${frontend_name}"
repo_dir="$repos_dir/$repo_name"
echo -e "${MSG}Running 'npm install' in ${repo_dir}...${NC}"
cd "$repo_dir"
npm install

webpack_command="$(npm bin)/webpack --config 'webpack.prod.config.js' --output-public-path '/${frontend_name}'"
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
