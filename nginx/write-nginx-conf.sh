#!/usr/bin/env bash
set -e
set -u
set -o pipefail

set +x
HOST_REDIRECTS=/edx/app/host-frontends.local
CUSTOM_CONFIG_TEMPLATE=/edx/app/devstack-frontends.nginx.tpl
CUSTOM_CONFIG_TEMPLATE=/edx/app/devstack-frontends.nginx.tpl
CUSTOM_CONFIG=/edx/app/devstack-frontends.nginx
CUSTOM_CONFIG_AVAILABLE=/etc/nginx/sites-available/devstack-frontends
CUSTOM_CONFIG_ENABLED=/etc/nginx/sites-enabled/devstack-frontends
DEFAULT_CONFIG_ENABLED=/etc/nginx/sites-enabled/default
set -x

# Generate nginx configuration from template and host redirects file.
# If that fails, just use template as config file.
rm -f "$CUSTOM_CONFIG"
(/edx/app/inject-host-redirects.sh \
	"$HOST_REDIRECTS" \
	"$CUSTOM_CONFIG_TEMPLATE" \
	> "$CUSTOM_CONFIG") || \
	cp "$CUSTOM_CONFIG_TEMPLATE" "$CUSTOM_CONFIG"

# Link custom configuration as available nginx site.
rm -f "$CUSTOM_CONFIG_AVAILABLE"
ln -s "$CUSTOM_CONFIG" "$CUSTOM_CONFIG_AVAILABLE"

# Enable custom configuration.
rm -f "$CUSTOM_CONFIG_ENABLED"
ln -s "$CUSTOM_CONFIG_AVAILABLE" "$CUSTOM_CONFIG_ENABLED"

# Disable default configuration
rm -f "$DEFAULT_CONFIG_ENABLED"
