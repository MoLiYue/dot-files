#!/usr/bin/env bash

set -euo pipefail

CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_CONFIG_HOME="$CONFIG_HOME"

"$CONFIG_HOME/scripts/theme-adapters.sh"
exec rofi "$@"
