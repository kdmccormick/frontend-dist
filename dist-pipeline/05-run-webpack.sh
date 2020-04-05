#!/usr/bin/env bash
. dist-pipeline/include.sh

repo_dir=repos/frontend-app-${frontend_name}
cd "$repo_dir"

output_public_path="--output-public-path='/${frontend_name}/'"
optimize_minimize="--optimize-minimize $WEBPACK_MINIMIZE"

echo -e "${MSG}Running webpack.${NC}" >&2
set -x
npm run build -- $output_public_path $optimize_minimize
set +x
