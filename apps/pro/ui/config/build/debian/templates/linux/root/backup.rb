#!/bin/sh

<%= render 'script_base_dir' %>

# Set up the environment
. "${BASE}/scripts/setenv.sh"

exec "${BASE}/apps/pro/ui/script/backup" "$@"
