#!/usr/bin/env bash
# Start SwayNC after ensuring its local theme adapter exists.

set -euo pipefail

CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_CONFIG_HOME="$CONFIG_HOME"

"$CONFIG_HOME/scripts/theme-adapters.sh"
exec swaync "$@"
