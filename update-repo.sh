#!/usr/bin/env bash
set -e
set -o pipefail

MSG='\033[0;32m'  # Green
NC='\033[0m'      # No Color

REPOS_DIR=repos
REPO_ROOT=https://github.com/edx/
REPO_NAME_PREFIX=frontend-app-

mkdir -p "$REPOS_DIR"

frontend_name="$1"
repo_name="${REPO_NAME_PREFIX}${frontend_name}"
repo_dir="$REPOS_DIR/$repo_name"

if [[ -d "$repo_dir/.git" ]]; then
	echo -e "${MSG}Resetting ${repo_dir} to head of origin/master...${NC}"
	cd "$repo_dir"
	git fetch
	git checkout . -f
	git reset --hard origin/master
else
	rm -rf "$repo_dir"  # Just in case part of the folder already exists.
	repo_url="${REPO_ROOT}/${repo_name}"
	echo -e "${MSG}Cloning head of ${repo_url}...${NC}"
	git clone "$repo_url" "$repo_dir" --depth 1 --single-branch
fi
