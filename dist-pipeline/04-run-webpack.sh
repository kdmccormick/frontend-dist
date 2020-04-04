#!/usr/bin/env bash
. dist-pipeline/include.sh

repo_dir=repos/frontend-app-${frontend_name}
cd "$repo_dir"

config="--config 'webpack.prod.config.js'"
output_public_path="--output-public-path='/${frontend_name}/'"
optimize_minimize="--optimize-minimize $WEBPACK_MINIMIZE" # TODO: Does this work?
webpack_command="npm run build -- $config $output_public_path $optimize_minimize"
echo -e "${MSG}Running webpack: ${webpack_command}${NC}" >&2
$webpack_command
