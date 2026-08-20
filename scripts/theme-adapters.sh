#!/usr/bin/env bash
# Maintain same-directory theme adapters for symlinked application configs.

set -euo pipefail

CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
THEME_LINK="$CONFIG_HOME/theme-current"
DEFAULT_THEME="$CONFIG_HOME/themes/catppuccin-mocha/apps"
STATE_FILE="$CONFIG_HOME/current-theme"

theme_is_complete() {
    local theme_dir="$1" required
    for required in waybar.css rofi.rasi kitty.conf swaync.css hyprland.lua; do
        [[ -s "$theme_dir/$required" ]] || return 1
    done
}

activate_default_theme() {
    if ! theme_is_complete "$DEFAULT_THEME"; then
        printf 'Default theme is incomplete: %s\n' "$DEFAULT_THEME" >&2
        return 1
    fi

    local theme_tmp="${THEME_LINK}.tmp.$$"
    local state_tmp="${STATE_FILE}.tmp.$$"
    rm -f -- "$theme_tmp"
    ln -s -- "$DEFAULT_THEME" "$theme_tmp"
    if ! mv -fT -- "$theme_tmp" "$THEME_LINK"; then
        rm -f -- "$theme_tmp"
        return 1
    fi

    printf '%s\n' catppuccin-mocha > "$state_tmp"
    mv -fT -- "$state_tmp" "$STATE_FILE"
}

link_adapter() {
    local source="$1" destination="$2" adapter_tmp
    mkdir -p "$(dirname "$destination")"

    if [[ -e "$destination" && ! -L "$destination" ]]; then
        printf 'Refusing to replace non-symlink theme adapter: %s\n' "$destination" >&2
        return 1
    fi

    if [[ -L "$destination" && "$(readlink "$destination")" == "$source" ]]; then
        return
    fi

    adapter_tmp="${destination}.tmp.$$"
    rm -f -- "$adapter_tmp"
    ln -s -- "$source" "$adapter_tmp"
    if ! mv -fT -- "$adapter_tmp" "$destination"; then
        rm -f -- "$adapter_tmp"
        return 1
    fi
}

if ! theme_is_complete "$THEME_LINK"; then
    activate_default_theme
fi

active_dir="$(readlink -f -- "$THEME_LINK")"
if ! theme_is_complete "$active_dir"; then
    printf 'Active theme could not be resolved: %s\n' "$THEME_LINK" >&2
    exit 1
fi

# Resolve the active directory before linking. The adapters remain usable even
# if theme-current is later missing, and none of their targets contain `..`.
link_adapter "$active_dir/waybar.css" "$CONFIG_HOME/waybar/colors.css"
link_adapter "$active_dir/rofi.rasi" "$CONFIG_HOME/rofi/colors.rasi"
link_adapter "$active_dir/swaync.css" "$CONFIG_HOME/swaync/colors.css"
