#!/usr/bin/env bash
. dist-pipeline/include.sh

src_dist_dir="repos/frontend-app-${frontend_name}/dist"
dst_dist_dir="dist/$frontend_name"

echo -e "${MSG}Copying contents of ${src_dist_dir}/ to ${dst_dist_dir}/${NC}" &>2
mkdir -p "$dst_dist_dir"
cp -r "$src_dist_dir"/* "$dst_dist_dir"/

report_file="$dst_dist_dir/report.html"
echo -e "${MSG}Removing ${report_file}; original report still available in repo.${NC}" &>2
rm -f "$report_file"
