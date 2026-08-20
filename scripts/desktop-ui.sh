#!/usr/bin/env bash
# Restore the selected theme before starting color-dependent desktop UI.

set -u

CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEFAULT_THEME="catppuccin-mocha"
state="$DEFAULT_THEME"

if [[ -s "$CONFIG_HOME/current-theme" ]]; then
    state="$(<"$CONFIG_HOME/current-theme")"
fi

if [[ "$state" == "wallpaper" ]]; then
    if ! "$SCRIPT_DIR/wallpaper.sh" --restore; then
        "$SCRIPT_DIR/apply-theme.sh" --restore "$DEFAULT_THEME"
    fi
else
    if ! "$SCRIPT_DIR/apply-theme.sh" --restore "$state"; then
        "$SCRIPT_DIR/apply-theme.sh" --restore "$DEFAULT_THEME"
    fi
    "$SCRIPT_DIR/wallpaper.sh" --set-only || true
fi

"$SCRIPT_DIR/swaync.sh" &
exec "$CONFIG_HOME/hypr/waybar.sh"
