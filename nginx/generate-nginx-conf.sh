#!/usr/bin/env bash
set -e
set -x
set -u
set -o pipefail

CUSTOM_CONFIG_TEMPLATE=/edx/app/devstack-frontends.nginx.tpl
CUSTOM_CONFIG=/edx/app/devstack-frontends.nginx
CUSTOM_CONFIG_AVAILABLE=/etc/nginx/sites-available/devstack-frontends
CUSTOM_CONFIG_ENABLED=/etc/nginx/sites-enabled/devstack-frontends
DEFAULT_CONFIG_ENABLED=/etc/nginx/sites-enabled/default

# Generate nginx configuration from template.
rm -f "$CUSTOM_CONFIG"
cp "$CUSTOM_CONFIG_TEMPLATE" "$CUSTOM_CONFIG"

# Link custom configuration as available nginx site.
rm -f "$CUSTOM_CONFIG_AVAILABLE"
ln -s "$CUSTOM_CONFIG" "$CUSTOM_CONFIG_AVAILABLE"

# Enable custom configuration.
rm -f "$CUSTOM_CONFIG_ENABLED"
ln -s "$CUSTOM_CONFIG_AVAILABLE" "$CUSTOM_CONFIG_ENABLED"

# Disable default configuration
rm -f "$DEFAULT_CONFIG_ENABLED"
