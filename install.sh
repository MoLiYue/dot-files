#!/bin/bash

# Hyprland WM
ln -s $PWD/waybar ~/.config/waybar
ln -s $PWD/hypr ~/.config/hypr
ln -s $PWD/wofi ~/.config/wofi

ln -s $PWD/fastfetch ~/.config/fastfetch

# Linux Common
ln -s $PWD/yazi ~/.config/yazi
ln -s $PWD/zshrc/.zshrc ~/.zshrc
ln -s $PWD/starship/starship.toml ~/.config/starship.toml
ln -s $PWD/tmux/tmux.conf ~/.config/tmux/tmux.conf
ln -s $PWD/nvim ~/.config/nvim

# install fonts
# yay -S
#
# install apps
# yay -S kitty wofi htop s-tui pacmixer wlogout
