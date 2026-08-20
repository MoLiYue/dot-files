#!/usr/bin/env bash
# theme-selector.sh — Rofi-based theme picker.
# Lists available themes, lets user select one, then applies it.

set -euo pipefail

THEME_DIR="${THEME_DIR:-$HOME/.config/themes}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Gather available themes (directory names)
themes=$(find -L "$THEME_DIR" -mindepth 1 -maxdepth 1 -type d -printf '%f\n' | sort)

if [[ -z "$themes" ]]; then
    notify-send -u critical "Theme Selector" "No themes found in $THEME_DIR"
    exit 1
fi

# Show rofi dmenu
selected=$(echo "$themes" | "$HOME/.config/rofi/launch.sh" -dmenu \
    -i \
    -p "Select Theme" \
    -theme "$HOME/.config/rofi/theme-selector.rasi"
)

# User cancelled
[[ -z "$selected" ]] && exit 0

# Apply theme
"$SCRIPT_DIR/apply-theme.sh" "$selected"
