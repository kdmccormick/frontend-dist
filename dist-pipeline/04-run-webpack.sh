#!/usr/bin/env bash
. dist-pipeline/include.sh

repo_dir=repos/frontend-app-${frontend_name}
cd "$repo_dir"

webpack_command="$(npm bin)/webpack --config 'webpack.prod.config.js' --output-public-path '/${frontend_name}'"
echo -e "${MSG}Running webpack: ${webpack_command}${NC}"
$webpack_command
