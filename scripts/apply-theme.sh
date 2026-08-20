#!/usr/bin/env bash
# Apply a fixed preset theme, or delegate to wallpaper-based Matugen colors.

set -euo pipefail

CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}/mlyue-theme"
THEME_DIR="${THEME_DIR:-$CONFIG_HOME/themes}"
THEME_LINK="$CONFIG_HOME/theme-current"
STATE_FILE="$CONFIG_HOME/current-theme"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
QUIET=false

usage() {
    echo "Usage: apply-theme.sh [--restore] <theme-name> | --wallpaper <image>" >&2
}

activate_theme_dir() {
    local target="$1"
    local required
    for required in waybar.css rofi.rasi kitty.conf swaync.css hyprland.lua; do
        if [[ ! -s "$target/$required" ]]; then
            echo "Theme adapter missing: $target/$required" >&2
            return 1
        fi
    done

    local link_tmp="${THEME_LINK}.tmp.$$"
    rm -f -- "$link_tmp"
    ln -s -- "$target" "$link_tmp"
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

render_legacy_preset() {
    local output="$CACHE_HOME/presets/$THEME_NAME"
    mkdir -p "$output"

    cat > "$output/waybar.css" <<EOF
/* Generated from preset: $THEME_NAME */
@define-color primary ${ACCENT};
@define-color on_primary ${BG};
@define-color primary_container ${SURFACE0};
@define-color on_primary_container ${FG};
@define-color secondary ${ACCENT_ALT};
@define-color on_secondary ${BG};
@define-color secondary_container ${SURFACE1};
@define-color on_secondary_container ${FG};
@define-color tertiary ${TEAL};
@define-color on_tertiary ${BG};
@define-color tertiary_container ${SURFACE1};
@define-color on_tertiary_container ${FG};
@define-color background ${BG};
@define-color on_background ${FG};
@define-color surface ${BG};
@define-color on_surface ${FG};
@define-color surface_variant ${SURFACE1};
@define-color on_surface_variant ${FG_DIM};
@define-color surface_container_lowest ${CRUST};
@define-color surface_container_low ${MANTLE};
@define-color surface_container ${SURFACE0};
@define-color surface_container_high ${SURFACE1};
@define-color surface_container_highest ${SURFACE2};
@define-color outline ${SURFACE2};
@define-color outline_variant ${SURFACE1};
@define-color error ${RED};
@define-color on_error ${BG};
@define-color error_container ${RED};
@define-color on_error_container ${BG};
@define-color inverse_surface ${FG};
@define-color inverse_on_surface ${BG};
@define-color inverse_primary ${BG};
@define-color rosewater ${ACCENT_ALT};
@define-color flamingo ${PINK};
@define-color pink ${PINK};
@define-color mauve ${MAUVE};
@define-color red ${RED};
@define-color maroon ${RED};
@define-color peach ${PEACH};
@define-color yellow ${YELLOW};
@define-color green ${GREEN};
@define-color teal ${TEAL};
@define-color sky ${ACCENT};
@define-color sapphire ${ACCENT};
@define-color blue ${ACCENT};
@define-color lavender ${ACCENT_ALT};
@define-color text ${FG};
@define-color subtext1 ${FG};
@define-color subtext0 ${FG_DIM};
@define-color overlay2 ${FG_DIM};
@define-color overlay1 ${SURFACE2};
@define-color overlay0 ${SURFACE2};
@define-color surface2 ${SURFACE2};
@define-color surface1 ${SURFACE1};
@define-color surface0 ${SURFACE0};
@define-color base ${BG};
@define-color mantle ${MANTLE};
@define-color crust ${CRUST};
EOF

    cat > "$output/rofi.rasi" <<EOF
/* Generated from preset: $THEME_NAME */
* {
    primary: ${ACCENT}; on-primary: ${BG};
    primary-container: ${SURFACE0}; on-primary-container: ${FG};
    secondary: ${ACCENT_ALT}; on-secondary: ${BG};
    secondary-container: ${SURFACE1}; on-secondary-container: ${FG};
    tertiary: ${TEAL}; on-tertiary: ${BG};
    tertiary-container: ${SURFACE1}; on-tertiary-container: ${FG};
    background: ${BG}; on-background: ${FG};
    surface: ${BG}; on-surface: ${FG};
    surface-variant: ${SURFACE1}; on-surface-variant: ${FG_DIM};
    surface-container-lowest: ${CRUST};
    surface-container-low: ${MANTLE};
    surface-container: ${SURFACE0};
    surface-container-high: ${SURFACE1};
    surface-container-highest: ${SURFACE2};
    outline: ${SURFACE2}; outline-variant: ${SURFACE1};
    error: ${RED}; on-error: ${BG};
    error-container: ${RED}; on-error-container: ${BG};
    inverse-surface: ${FG}; inverse-on-surface: ${BG}; inverse-primary: ${BG};
    bg: @background; bg-alt: @surface-container;
    fg: @on-background; fg-alt: @on-surface-variant;
    selected: @primary; active: @tertiary; urgent: @error;
}
EOF

    cat > "$output/kitty.conf" <<EOF
# Generated from preset: $THEME_NAME
foreground ${FG}
background ${BG}
selection_foreground ${BG}
selection_background ${ACCENT}
cursor ${ACCENT}
cursor_text_color ${BG}
url_color ${TEAL}
active_border_color ${ACCENT_ALT}
inactive_border_color ${SURFACE2}
bell_border_color ${YELLOW}
active_tab_foreground ${BG}
active_tab_background ${ACCENT}
inactive_tab_foreground ${FG}
inactive_tab_background ${MANTLE}
tab_bar_background ${CRUST}
color0 ${SURFACE1}
color1 ${RED}
color2 ${GREEN}
color3 ${YELLOW}
color4 ${ACCENT}
color5 ${PINK}
color6 ${TEAL}
color7 ${FG}
color8 ${SURFACE2}
color9 ${RED}
color10 ${GREEN}
color11 ${YELLOW}
color12 ${ACCENT}
color13 ${MAUVE}
color14 ${TEAL}
color15 ${FG_DIM}
EOF

    cat > "$output/swaync.css" <<EOF
/* Generated from preset: $THEME_NAME */
@define-color primary ${ACCENT};
@define-color on_primary ${BG};
@define-color primary_container ${SURFACE0};
@define-color secondary ${ACCENT_ALT};
@define-color tertiary ${TEAL};
@define-color background ${BG};
@define-color on_background ${FG};
@define-color surface ${BG};
@define-color on_surface ${FG};
@define-color surface_variant ${SURFACE1};
@define-color on_surface_variant ${FG_DIM};
@define-color surface_container ${SURFACE0};
@define-color surface_container_high ${SURFACE1};
@define-color surface_container_highest ${SURFACE2};
@define-color outline ${SURFACE2};
@define-color outline_variant ${SURFACE1};
@define-color error ${RED};
@define-color on_error ${BG};
@define-color error_container ${RED};
@define-color inverse_surface ${FG};
EOF

    cat > "$output/hyprland.lua" <<EOF
return {
    active_border = { "${HYPR_ACTIVE_BORDER%% *}", "rgb(${ACCENT#\#})", "rgb(${ACCENT_ALT#\#})" },
    active_border_hyprctl = "${HYPR_ACTIVE_BORDER}",
    inactive_border = "${HYPR_INACTIVE_BORDER}",
    primary = "rgb(${ACCENT#\#})",
    outline_variant = "rgb(${SURFACE1#\#})",
}
EOF

    printf '%s\n' "$output"
}

if [[ "${1:-}" == "--restore" ]]; then
    QUIET=true
    shift
fi

if [[ "${1:-}" == "--wallpaper" ]]; then
    [[ -n "${2:-}" ]] || { usage; exit 1; }
    "$SCRIPT_DIR/wallpaper.sh" "$2"
    exit 0
fi

theme_name="${1:-}"
[[ -n "$theme_name" ]] || { usage; exit 1; }
theme_path="$THEME_DIR/$theme_name"

if [[ ! -f "$theme_path/colors.sh" ]]; then
    echo "Theme '$theme_name' is missing colors.sh" >&2
    exit 1
fi

# shellcheck source=/dev/null
source "$theme_path/colors.sh"

if [[ -d "$theme_path/apps" ]]; then
    active_dir="$theme_path/apps"
else
    active_dir="$(render_legacy_preset)"
fi

activate_theme_dir "$active_dir"
"$SCRIPT_DIR/theme-adapters.sh"
printf '%s\n' "$theme_name" > "$STATE_FILE"

reload_hyprland
if [[ -n "${GTK_THEME:-}" ]]; then
    hyprctl eval "hl.env([=[GTK_THEME]=], [=[$GTK_THEME]=])" 2>/dev/null || true
fi

if [[ -n "${WALLPAPER:-}" && -f "$WALLPAPER" ]]; then
    "$SCRIPT_DIR/wallpaper.sh" --set-only "$WALLPAPER"
fi

reload_apps

if [[ "$QUIET" == false ]]; then
    notify-send "Theme Applied" "Switched to: ${THEME_DISPLAY_NAME:-$theme_name}" 2>/dev/null || true
fi
