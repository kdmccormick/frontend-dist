#!/usr/bin/env bash
. dist-pipeline/include.sh

repo_dir=repos/frontend-app-${frontend_name}
cd "$repo_dir"

echo -e "${MSG}Running webpack.${NC}" >&2
set -x
npm run build -- --optimize-minimize="$WEBPACK_MINIMIZE"
set +x
