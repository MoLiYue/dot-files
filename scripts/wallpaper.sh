#!/usr/bin/env bash
# wallpaper.sh — Set wallpaper via awww and generate Material You colors via matugen.
# Usage:
#   wallpaper.sh              — start daemon + apply saved/default wallpaper
#   wallpaper.sh <path>       — set a specific wallpaper + regenerate colors
#   wallpaper.sh random       — pick a random wallpaper

set -euo pipefail

WALLPAPER_DIR="${WALLPAPER_DIR:-$HOME/Pictures/wallpapers}"
STATE_FILE="$HOME/.config/current-wallpaper"
MATUGEN_MODE="${MATUGEN_MODE:-dark}"

# Transition settings
TRANSITION_TYPE="fade"
TRANSITION_DURATION=1
TRANSITION_FPS=60
TRANSITION_STEP=2

# Start awww daemon if not running
if ! pgrep -x awww-daemon >/dev/null 2>&1; then
    awww-daemon &
    sleep 0.5
fi

apply_wallpaper() {
    local img="$1"
    if [[ ! -f "$img" ]]; then
        echo "Wallpaper not found: $img" >&2
        return 1
    fi

    # Set wallpaper with transition
    awww img "$img" \
        --transition-type "$TRANSITION_TYPE" \
        --transition-duration "$TRANSITION_DURATION" \
        --transition-fps "$TRANSITION_FPS" \
        --transition-step "$TRANSITION_STEP"

    # Generate Material You colors from wallpaper
    matugen image "$img" -m "$MATUGEN_MODE" 2>/dev/null || true

    # Reload SwayNC styles
    swaync-client --reload-css 2>/dev/null || true

    # Update Hyprland border colors from generated lua
    if [[ -f "$HOME/.config/hypr/matugen-colors.lua" ]]; then
        # Source the colors and apply border
        local primary
        primary=$(grep 'primary =' "$HOME/.config/hypr/matugen-colors.lua" | head -1 | grep -o '"[^"]*"' | tr -d '"')
        local outline
        outline=$(grep 'outline_variant =' "$HOME/.config/hypr/matugen-colors.lua" | grep -o '"[^"]*"' | tr -d '"')
        if [[ -n "$primary" ]]; then
            hyprctl keyword general:col.active_border "$primary" 2>/dev/null || true
        fi
        if [[ -n "$outline" ]]; then
            hyprctl keyword general:col.inactive_border "$outline" 2>/dev/null || true
        fi
    fi

    # Save current wallpaper path
    echo "$img" > "$STATE_FILE"
}

pick_random() {
    if [[ ! -d "$WALLPAPER_DIR" ]]; then
        echo "Wallpaper directory not found: $WALLPAPER_DIR" >&2
        return 1
    fi

    local img
    img=$(find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" -o -name "*.webp" -o -name "*.gif" \) | shuf -n 1)

    if [[ -z "$img" ]]; then
        echo "No wallpapers found in $WALLPAPER_DIR" >&2
        return 1
    fi

    apply_wallpaper "$img"
}

# Main logic
case "${1:-}" in
    random)
        pick_random
        ;;
    "")
        # Restore saved wallpaper, or pick random
        if [[ -f "$STATE_FILE" ]] && [[ -f "$(cat "$STATE_FILE")" ]]; then
            apply_wallpaper "$(cat "$STATE_FILE")"
        elif [[ -d "$WALLPAPER_DIR" ]]; then
            pick_random
        fi
        ;;
    *)
        apply_wallpaper "$1"
        ;;
esac
