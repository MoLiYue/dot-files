#!/usr/bin/env bash
# apply-theme.sh — Apply a theme across all desktop components.
# Usage: apply-theme.sh <theme-name>

set -euo pipefail

THEME_DIR="${THEME_DIR:-$HOME/.config/themes}"
THEME_NAME="${1:-}"

if [[ -z "$THEME_NAME" ]]; then
    echo "Usage: apply-theme.sh <theme-name>" >&2
    exit 1
fi

THEME_PATH="$THEME_DIR/$THEME_NAME"

if [[ ! -d "$THEME_PATH" ]]; then
    notify-send -u critical "Theme Error" "Theme '$THEME_NAME' not found"
    exit 1
fi

if [[ ! -f "$THEME_PATH/colors.sh" ]]; then
    notify-send -u critical "Theme Error" "Missing colors.sh in '$THEME_NAME'"
    exit 1
fi

# shellcheck source=/dev/null
source "$THEME_PATH/colors.sh"

# -----------------------------------------------------------
# 1. Waybar — regenerate mocha.css with new colors
# -----------------------------------------------------------
apply_waybar() {
    local css="$HOME/.config/waybar/mocha.css"
    cat > "$css" <<EOF
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
    # Restart waybar to pick up new CSS
    pkill waybar 2>/dev/null || true
    sleep 0.3
    "$HOME/.config/hypr/waybar.sh" &
}

# -----------------------------------------------------------
# 2. Hyprland — update border colors and GTK env
# -----------------------------------------------------------
apply_hyprland() {
    # Border colors
    hyprctl keyword general:col.active_border "$HYPR_ACTIVE_BORDER" 2>/dev/null || true
    hyprctl keyword general:col.inactive_border "$HYPR_INACTIVE_BORDER" 2>/dev/null || true

    # GTK theme env
    if [[ -n "${GTK_THEME:-}" ]]; then
        hyprctl keyword env "GTK_THEME,$GTK_THEME" 2>/dev/null || true
    fi
}

# -----------------------------------------------------------
# 3. Kitty — switch theme include
# -----------------------------------------------------------
apply_kitty() {
    if [[ -z "${KITTY_THEME:-}" ]]; then
        return
    fi

    local kitty_conf="$HOME/.config/kitty/kitty.conf"
    if [[ -f "$kitty_conf" ]]; then
        # Replace the include line for the theme
        sed -i "s|^include kitty/themes/.*|include $KITTY_THEME|" "$kitty_conf"
        # Reload all kitty instances
        pkill -USR1 kitty 2>/dev/null || true
    fi
}

# -----------------------------------------------------------
# 4. SwayNC — regenerate colors in style
# -----------------------------------------------------------
apply_swaync() {
    local css="$HOME/.config/swaync/style.css"
    if [[ -f "$css" ]]; then
        sed -i \
            -e "s|@define-color rosewater .*|@define-color rosewater ${ACCENT_ALT};|" \
            -e "s|@define-color flamingo .*|@define-color flamingo ${PINK};|" \
            -e "s|@define-color pink .*|@define-color pink ${PINK};|" \
            -e "s|@define-color mauve .*|@define-color mauve ${MAUVE};|" \
            -e "s|@define-color red .*|@define-color red ${RED};|" \
            -e "s|@define-color maroon .*|@define-color maroon ${RED};|" \
            -e "s|@define-color peach .*|@define-color peach ${PEACH};|" \
            -e "s|@define-color yellow .*|@define-color yellow ${YELLOW};|" \
            -e "s|@define-color green .*|@define-color green ${GREEN};|" \
            -e "s|@define-color teal .*|@define-color teal ${TEAL};|" \
            -e "s|@define-color sky .*|@define-color sky ${ACCENT};|" \
            -e "s|@define-color sapphire .*|@define-color sapphire ${ACCENT};|" \
            -e "s|@define-color blue .*|@define-color blue ${ACCENT};|" \
            -e "s|@define-color lavender .*|@define-color lavender ${ACCENT_ALT};|" \
            -e "s|@define-color text .*|@define-color text ${FG};|" \
            -e "s|@define-color subtext1 .*|@define-color subtext1 ${FG};|" \
            -e "s|@define-color subtext0 .*|@define-color subtext0 ${FG_DIM};|" \
            -e "s|@define-color overlay2 .*|@define-color overlay2 ${FG_DIM};|" \
            -e "s|@define-color overlay1 .*|@define-color overlay1 ${SURFACE2};|" \
            -e "s|@define-color overlay0 .*|@define-color overlay0 ${SURFACE2};|" \
            -e "s|@define-color surface2 .*|@define-color surface2 ${SURFACE2};|" \
            -e "s|@define-color surface1 .*|@define-color surface1 ${SURFACE1};|" \
            -e "s|@define-color surface0 .*|@define-color surface0 ${SURFACE0};|" \
            -e "s|@define-color base .*|@define-color base ${BG};|" \
            -e "s|@define-color mantle .*|@define-color mantle ${MANTLE};|" \
            -e "s|@define-color crust .*|@define-color crust ${CRUST};|" \
            "$css"
        # Reload swaync
        swaync-client --reload-css 2>/dev/null || true
    fi
}

# -----------------------------------------------------------
# 5. Wallpaper (optional)
# -----------------------------------------------------------
apply_wallpaper() {
    if [[ -z "${WALLPAPER:-}" ]]; then
        return
    fi

    if command -v swww >/dev/null 2>&1; then
        swww img "$WALLPAPER" --transition-type fade --transition-duration 1
    elif command -v hyprctl >/dev/null 2>&1; then
        hyprctl hyprpaper wallpaper ",$WALLPAPER" 2>/dev/null || true
    fi
}

# -----------------------------------------------------------
# 6. Save current theme for persistence
# -----------------------------------------------------------
save_current() {
    echo "$THEME_NAME" > "$HOME/.config/current-theme"
}

# -----------------------------------------------------------
# Execute all
# -----------------------------------------------------------
apply_waybar
apply_hyprland
apply_kitty
apply_swaync
apply_wallpaper
save_current

notify-send "Theme Applied" "Successfully switched to: ${THEME_DISPLAY_NAME:-$THEME_NAME}"
