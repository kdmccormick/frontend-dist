#!/usr/bin/env bash
. dist-pipeline/include.sh

repo_dir=repos/frontend-app-${frontend_name}
cd "$repo_dir"

echo -e "${MSG}Running webpack.${NC}" >&2
set -x
npm run dev-build -- --output-public-path="/${frontend_name}/"
set +x
