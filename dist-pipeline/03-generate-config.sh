#!/usr/bin/env bash
. dist-pipeline/include.sh

common_env_file=config/common.env
frontend_env_file=config/${frontend_name}.env
repo_env_file=repos/frontend-app-${frontend_name}/.env

echo >> "$repo_env_file"
echo >> "$repo_env_file"
echo >> "$repo_env_file"
echo "# Written from $common_env_file by $0" >> "$repo_env_file"
cat "$common_env_file" | sed -e "/^#\!/d" >> "$repo_env_file"

echo >> "$repo_env_file"
echo >> "$repo_env_file"
echo >> "$repo_env_file"
if test -f "$frontend_env_file"; then
	echo "# Written from $frontend_env_file by $0" >> "$repo_env_file"
	cat "$frontend_env_file" | sed -e "/^#\!/d"  >> "$repo_env_file"
fi
