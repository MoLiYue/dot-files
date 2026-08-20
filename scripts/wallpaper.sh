#!/usr/bin/env bash
# Set a wallpaper and optionally activate a Matugen-generated color theme.

set -euo pipefail

CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}/mlyue-theme"
WALLPAPER_THEME="$CACHE_HOME/wallpaper"
WALLPAPER_DIR="${WALLPAPER_DIR:-$HOME/Pictures/wallpapers}"
WALLPAPER_STATE="$CONFIG_HOME/current-wallpaper"
THEME_STATE="$CONFIG_HOME/current-theme"
THEME_LINK="$CONFIG_HOME/theme-current"
MATUGEN_MODE="${MATUGEN_MODE:-dark}"
MATUGEN_SOURCE_COLOR_INDEX="${MATUGEN_SOURCE_COLOR_INDEX:-0}"
GENERATE_THEME=true
QUIET=false

activate_theme_dir() {
    local required
    for required in waybar.css rofi.rasi kitty.conf swaync.css hyprland.lua; do
        [[ -s "$WALLPAPER_THEME/$required" ]] || {
            echo "Matugen output missing: $WALLPAPER_THEME/$required" >&2
            return 1
        }
    done

    local link_tmp="${THEME_LINK}.tmp.$$"
    rm -f -- "$link_tmp"
    ln -s -- "$WALLPAPER_THEME" "$link_tmp"
    mv -fT -- "$link_tmp" "$THEME_LINK"
}

reload_apps() {
    killall -SIGUSR2 waybar 2>/dev/null || true
    pkill -USR1 kitty 2>/dev/null || true
    swaync-client --reload-css 2>/dev/null || true
}

reload_hyprland() {
    hyprctl eval "local c = dofile([=[$THEME_LINK/hyprland.lua]=]); hl.config({ general = { col = { active_border = { colors = c.active_border }, inactive_border = c.inactive_border } } })" \
        2>/dev/null || true
}

choose_wallpaper() {
    local requested="${1:-}"
    if [[ -n "$requested" && "$requested" != "random" ]]; then
        [[ -f "$requested" ]] || { echo "Wallpaper not found: $requested" >&2; return 1; }
        printf '%s\n' "$requested"
        return
    fi

    if [[ -z "$requested" && -f "$WALLPAPER_STATE" ]]; then
        local saved
        saved="$(<"$WALLPAPER_STATE")"
        if [[ -f "$saved" ]]; then
            printf '%s\n' "$saved"
            return
        fi
    fi

    [[ -d "$WALLPAPER_DIR" ]] || return 1
    find "$WALLPAPER_DIR" -type f \
        \( -name '*.jpg' -o -name '*.jpeg' -o -name '*.png' -o -name '*.webp' -o -name '*.gif' \) \
        | shuf -n 1
}

set_wallpaper() {
    local img="$1"
    if ! pgrep -x awww-daemon >/dev/null 2>&1; then
        awww-daemon &
        sleep 0.5
    fi

    awww img "$img" \
        --transition-type fade \
        --transition-duration 1 \
        --transition-fps 60 \
        --transition-step 2
    printf '%s\n' "$img" > "$WALLPAPER_STATE"
}

apply_wallpaper_theme() {
    local img="$1"
    mkdir -p "$WALLPAPER_THEME"

    if ! matugen image "$img" --mode "$MATUGEN_MODE" \
        --config "$CONFIG_HOME/matugen/config.toml" \
        --source-color-index "$MATUGEN_SOURCE_COLOR_INDEX"; then
        notify-send -u critical "Theme Error" "Matugen could not generate wallpaper colors" 2>/dev/null || true
        return 1
    fi

    activate_theme_dir
    "$CONFIG_HOME/scripts/theme-adapters.sh"
    printf '%s\n' wallpaper > "$THEME_STATE"

    reload_hyprland
    reload_apps
}

case "${1:-}" in
    --restore)
        QUIET=true
        shift
        ;;
    --set-only)
        GENERATE_THEME=false
        QUIET=true
        shift
        ;;
esac

requested="${1:-}"
img="$(choose_wallpaper "$requested")" || {
    [[ -z "$requested" ]] && exit 0
    exit 1
}

set_wallpaper "$img"
if [[ "$GENERATE_THEME" == true ]]; then
    apply_wallpaper_theme "$img"
    if [[ "$QUIET" == false ]]; then
        notify-send "Theme Applied" "Generated colors from $(basename "$img")" 2>/dev/null || true
    fi
fi
