#!/usr/bin/env bash
. dist-pipeline/include.sh

repo_root=repos/frontend-app-${frontend_name}

# Strip leading slashes in order to make paths relative.
# This will replace all occurances of
#   path="/
# with:
#   path="
# and with repalce all occurances of
#   path='/
# with:
#   path='
# and, specifically for the Learning MFE, replace all occurances of
#   '/course/:courseId
# with:
#   'course/:courseId
index_jsx=${repo_root}/src/index.jsx
if [[ -f "$index_jsx" ]]; then
	echo -e "${MSG}Making routes relative.${NC}" >&2
	set -x
	sed -i -e "s/path=\"\\//path=\"/g" "$index_jsx"
	sed -i -e "s/path='\\//path='/g" "$index_jsx"
	sed -i -e "s/'\\/course\\/:courseId/'course\\/:courseId/g" "$index_jsx"
	set +x
else
	echo -e "${WARN}No such file '$index_jsx'; cannot make routes relative.${NC}" >&2
fi
