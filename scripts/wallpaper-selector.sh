#!/usr/bin/env bash
# wallpaper-selector.sh — Rofi-based wallpaper picker.
# Lists wallpapers from ~/Pictures/wallpapers, lets user select one.

set -euo pipefail

WALLPAPER_DIR="${WALLPAPER_DIR:-$HOME/Pictures/wallpapers}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ ! -d "$WALLPAPER_DIR" ]]; then
    notify-send -u critical "Wallpaper Selector" "Directory not found: $WALLPAPER_DIR"
    exit 1
fi

# List wallpapers (filename only for display)
wallpapers=$(find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" -o -name "*.webp" -o -name "*.gif" \) | sort)

if [[ -z "$wallpapers" ]]; then
    notify-send -u critical "Wallpaper Selector" "No wallpapers found"
    exit 1
fi

# Build display list (basename for user, full path for lookup)
display_list=$(echo "$wallpapers" | while read -r f; do basename "$f"; done)

# Add "Random" option at top
display_list=$(printf "🎲 Random\n%s" "$display_list")

selected=$(echo "$display_list" | rofi -dmenu \
    -i \
    -p "Wallpaper" \
    -theme "$HOME/.config/rofi/theme-selector.rasi"
)

[[ -z "$selected" ]] && exit 0

if [[ "$selected" == "🎲 Random" ]]; then
    "$SCRIPT_DIR/wallpaper.sh" random
else
    # Find full path from selection
    full_path=$(echo "$wallpapers" | grep "/${selected}$" | head -1)
    if [[ -n "$full_path" ]]; then
        "$SCRIPT_DIR/wallpaper.sh" "$full_path"
    else
        notify-send -u critical "Wallpaper Selector" "File not found: $selected"
        exit 1
    fi
fi

notify-send "Wallpaper" "Applied: $selected"
