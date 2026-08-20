#!/bin/bash
set -euo pipefail

# Resolve the repo root (where this script lives)
DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Helper: create symlink, skip if already correct
link() {
    local src="$1" dst="$2"
    mkdir -p "$(dirname "$dst")"
    if [[ -L "$dst" && "$(readlink "$dst")" == "$src" ]]; then
        return
    fi
    ln -sfn "$src" "$dst"
    echo "  $dst → $src"
}

echo "Installing dotfiles from $DOTFILES"

# Hyprland WM
link "$DOTFILES/hypr"       "$HOME/.config/hypr"
link "$DOTFILES/waybar"     "$HOME/.config/waybar"
link "$DOTFILES/rofi"       "$HOME/.config/rofi"
link "$DOTFILES/swaync"     "$HOME/.config/swaync"
link "$DOTFILES/matugen"    "$HOME/.config/matugen"
link "$DOTFILES/mpd"        "$HOME/.config/mpd"
link "$DOTFILES/rmpc"       "$HOME/.config/rmpc"
link "$DOTFILES/themes"     "$HOME/.config/themes"
link "$DOTFILES/scripts"    "$HOME/.config/scripts"
link "$DOTFILES/kitty"      "$HOME/.config/kitty"

# General tools
link "$DOTFILES/fastfetch"  "$HOME/.config/fastfetch"
link "$DOTFILES/yazi"       "$HOME/.config/yazi"
link "$DOTFILES/nvim"       "$HOME/.config/nvim"
link "$DOTFILES/starship/starship.toml" "$HOME/.config/starship.toml"
link "$DOTFILES/tmux/tmux.conf"         "$HOME/.config/tmux/tmux.conf"
link "$DOTFILES/zshrc/.zshrc"           "$HOME/.zshrc"

# Default theme. The link is replaced atomically by apply-theme.sh or
# wallpaper.sh when another fixed or wallpaper-derived theme is selected.
THEME_LINK="$HOME/.config/theme-current"
DEFAULT_THEME="$HOME/.config/themes/catppuccin-mocha/apps"
if [[ ! -r "$THEME_LINK/waybar.css" ]]; then
    theme_tmp="${THEME_LINK}.tmp.$$"
    rm -f -- "$theme_tmp"
    ln -s -- "$DEFAULT_THEME" "$theme_tmp"
    mv -fT -- "$theme_tmp" "$THEME_LINK"
fi
if [[ ! -s "$HOME/.config/current-theme" ]]; then
    printf '%s\n' catppuccin-mocha > "$HOME/.config/current-theme"
fi
"$HOME/.config/scripts/theme-adapters.sh"

echo "Done."

# install fonts
# sudo pacman -S ttf-jetbrains-mono-nerd otf-font-awesome ttf-nerd-fonts-symbols
#
# install apps
# sudo pacman -S kitty rofi swaync awww matugen mpd rmpc htop s-tui pacmixer wlogout
