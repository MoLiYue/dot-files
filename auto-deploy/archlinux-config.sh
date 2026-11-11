#! /bin/bash
#

# 更换镜像源

# 
# 更新系统
pacman -Syyu

# 安装yay
pacman -S --needed git base-devel && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si

# install software
# 性能监测软件
yay -S conky

