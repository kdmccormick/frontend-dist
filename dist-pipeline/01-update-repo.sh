#!/usr/bin/env bash
. dist-pipeline/include.sh

mkdir -p repos
repo_dir="repos/${repo_name}"
branch="kdmccormick/devstack-frontends"

if [[ -d "$repo_dir/.git" ]]; then
	echo -e "${MSG}Resetting ${repo_dir} to head of origin/master...${NC}" >&2
	cd "$repo_dir"
	git fetch
	git checkout "$branch" -f
	git reset --hard origin/"$branch"
	git clean -f
else
	rm -rf "$repo_dir"  # Just in case part of the folder already exists.
	repo_url="https://github.com/edx/${repo_name}"
	echo -e "${MSG}Cloning head of ${repo_url}...${NC}" >&2
	git clone "$repo_url" "$repo_dir" --depth 1 --single-branch --branch "$branch"
fi
