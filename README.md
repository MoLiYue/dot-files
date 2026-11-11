# Readme

## Hyprland

### 音频栈（WiVRn / VRChat）

Hyprland 桌面的音频栈已从旧的混合方案迁移到完整的 PipeWire
方案，便于 WiVRn 动态创建和路由虚拟扬声器、麦克风。

软件变动：

| 原软件 | 现软件 | 说明 |
| --- | --- | --- |
| `pipewire-media-session` | `wireplumber` | 使用 WirePlumber 管理 PipeWire 设备、策略和路由 |
| `pulseaudio` | `pipewire-pulse` | 由 PipeWire 提供 PulseAudio 兼容接口，供 Steam、Wine/Proton、VRChat 等软件使用 |
| `pulseaudio-bluetooth` | `pipewire-audio` + `wireplumber` | 蓝牙音频改由 PipeWire 音频栈管理，不需要额外安装 `pipewire-bluetooth` |

最终使用的软件包：

```text
pipewire
pipewire-audio
pipewire-pulse
wireplumber
```

迁移命令：

```bash
sudo pacman -Rns pulseaudio-bluetooth
sudo pacman -S pipewire pipewire-audio pipewire-pulse wireplumber
systemctl --user restart pipewire pipewire-pulse wireplumber
```

安装过程中如果提示以下冲突，确认移除旧软件即可：

```text
wireplumber <-> pipewire-media-session
pipewire-pulse <-> pulseaudio
```

检查服务和音频路由：

```bash
systemctl --user --no-pager status pipewire pipewire-pulse wireplumber
wpctl status
```

WiVRn 只会在头显连接后创建虚拟音频节点。连接 Quest 后，`wpctl
status` 中应出现 `WiVRn` 扬声器和 `WiVRn (microphone)` 麦克风。可将
WiVRn 扬声器设为默认输出：

```bash
wpctl set-default <WiVRn-sink-id>
```

已有的 VRChat 音频流不一定会自动迁移到新的默认输出；可以重启
VRChat，或安装 `pavucontrol` 后在 Playback 页面手动切换：

```bash
sudo pacman -S pavucontrol
```

## feh

```bash
xdg-mime default feh.desktop image/jpeg
xdg-mime default feh.desktop image/png
xdg-mime default feh.desktop image/jpg
```

add `--fullscreen --borderless --zoom fill --auto-zoom --scale-down --hide-pointer` to feh.desktop
