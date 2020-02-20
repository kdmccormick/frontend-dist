#!/usr/bin/env bash
. dist-pipeline/include.sh

repo_dir=repos/frontend-app-${frontend_name}
cd "$repo_dir"

webpack_command="$(npm bin)/webpack --config 'webpack.prod.config.js'"
webpack_command="$webpack_command --output-public-path '/${frontend_name}/'"
# TODO: why doesn't the next line do anything when uncommented?
# webpack_command="$webpack_command --optimize-minimize $WEBPACK_MINIMIZE"
echo -e "${MSG}Running webpack: ${webpack_command}${NC}" >&2
$webpack_command
