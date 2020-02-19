#!/usr/bin/env bash
. dist-pipeline/include.sh

mkdir -p repos
repo_name=frontend-app-${frontend_name}
repo_dir="repos/${repo_name}"

if [[ -d "$repo_dir/.git" ]]; then
	echo -e "${MSG}Resetting ${repo_dir} to head of origin/master...${NC}"
	cd "$repo_dir"
	git fetch
	git checkout . -f
	git reset --hard origin/master
else
	rm -rf "$repo_dir"  # Just in case part of the folder already exists.
	repo_url="https://github.com/edx/${repo_name}"
	echo -e "${MSG}Cloning head of ${repo_url}...${NC}"
	git clone "$repo_url" "$repo_dir" --depth 1 --single-branch
fi