# Hyprland 桌面配置

这份文档记录当前 Arch Linux 设备上实际使用的 Hyprland 桌面组件、启动关系、快捷键，以及 Waybar 可以唤起的软件。

状态说明：

- ✅ 已安装并正在使用
- ⚠️ 有配置，但当前缺少依赖、资源或后台服务
- ❌ 当前没有安装或启用

## 当前桌面结构

```text
Hyprland ✅
├── Waybar ✅                         状态栏 / 软件入口 / 系统控制
│   ├── 左侧
│   │   ├── Media ⚠                  mediaplayer.py 缺失
│   │   ├── App Menu ⚠               模块未定义，暂时不能点击启动 Rofi
│   │   ├── Taskbar ✅                左键聚焦窗口，中键关闭窗口
│   │   └── 当前窗口标题 ✅
│   ├── 中间
│   │   └── Workspaces ✅             点击切换工作区
│   └── 右侧
│       ├── MPD ⚠                    已安装，后台没有运行
│       ├── 音频 ✅                   点击打开 Kitty + pacmixer
│       ├── 网络 ✅                   点击打开 Kitty + nmtui
│       ├── 电源模式 ⚠               power-profiles-daemon 缺失
│       ├── 温度 ✅                   点击打开 Kitty + s-tui
│       ├── 背光 ⚠                   配置的 acpi_video1 设备不存在
│       ├── 键盘状态 ✅
│       ├── 电池 ⚠                   当前设备没有 BAT0/BAT2
│       ├── Hardware 折叠组
│       │   ├── 磁盘 ✅               仅显示
│       │   ├── CPU ✅                点击打开 Kitty + htop
│       │   ├── 内存 ✅               仅显示
│       │   └── GPU ✅                点击打开 Kitty + nvtop
│       ├── 电源按钮 ✅               点击打开 wlogout
│       ├── 时钟 ✅
│       └── Tray ✅                   后台程序提供的动态入口
├── Rofi ✅                           应用启动器，Super + R
├── SwayNC ✅                         通知守护进程 + 通知中心
├── awww ✅                           壁纸守护进程，支持动画过渡
├── Hypridle ⚠                       有配置，但程序和服务未启用
├── Hyprlock ✅                       锁屏，Super + Shift + L
├── Hyprpolkitagent ✅                图形密码授权窗口，只运行一个代理
├── Grim + Slurp + Satty ✅           区域截图与标注
├── Wlogout ✅                        会话和电源菜单
├── Fcitx5 ✅                         输入法
├── PipeWire + WirePlumber ✅         音频服务
├── XDG Desktop Portal ⚠             缺少 Hyprland portal 后端
└── 自定义 Lua / Shell 脚本 ✅
```

## 配置入口

`~/.config/hypr` 链接到仓库中的 `hypr/`，当前入口是 Lua 配置：

```text
hypr/
├── hyprland.lua                     主配置入口
├── mocha.lua                        Catppuccin Mocha 色板
├── hyprtoolkit.conf                 Hyprland Toolkit 的 Catppuccin 配色
├── hyprlock.conf                    锁屏界面
├── hypridle.conf                    空闲、锁屏、熄屏和挂起规则
├── waybar.sh                        启动 Waybar并监听配置变化
├── xdg-desktop-portal-hyprland.sh   Portal 启动脚本
└── conf/
    ├── autostart.lua                会话自启动项
    ├── inputdevice.lua              输入设备
    ├── cursor.conf                  光标
    ├── animations/                  动画
    ├── environments/                环境变量
    ├── keybindings/                 快捷键
    ├── monitors/                    显示器
    ├── windowrules/                 窗口规则
    └── workspaces/                  工作区
```

`hyprland.conf` 是尚未纳入当前 Lua 入口的旧配置残留；维护时应优先修改 `hyprland.lua` 和 `conf/` 下的模块。

## 会话启动关系

Hyprland 启动后由 `conf/autostart.lua` 拉起：

```text
Hyprland
├── systemctl --user start hyprpolkitagent.service
├── swaync
├── wallpaper.sh (awww-daemon + restore wallpaper)
├── fcitx5 -d --replace
├── fcitx5-remote -r
├── xdg-desktop-portal-hyprland.sh
└── waybar.sh
```

`hyprpolkitagent` 是应用执行系统管理操作时弹出的密码授权窗口。KDE 的 Polkit Agent 虽然随 KDE 安装，但当前没有同时运行，因此不会出现两个密码窗口互相竞争。

Portal 启动脚本会尝试启动 `/usr/lib/xdg-desktop-portal-hyprland`，但当前设备没有安装该后端。现有的 `xdg-desktop-portal` 和 GTK 后端无法完整提供 Hyprland 下的屏幕共享；需要安装并启用 `xdg-desktop-portal-hyprland` 后再验证。

## Waybar 软件入口

Waybar 不只是状态显示栏，也是当前桌面的快捷控制入口。

| 模块 | 操作 | 实际效果 | 当前状态 |
| --- | --- | --- | --- |
| Taskbar | 左键 | 聚焦选中的运行中窗口 | ✅ |
| Taskbar | 中键 | 关闭选中的窗口 | ✅ |
| Workspaces | 左键 | 切换到对应工作区 | ✅ |
| 音频 | 左键 | `kitty pacmixer` | ✅ |
| 网络 | 左键 | `kitty nmtui` | ✅ |
| 温度 | 左键 | `kitty s-tui` | ✅ |
| CPU | 左键 | `kitty htop` | ✅ |
| GPU | 左键 | `kitty nvtop` | ✅ |
| 电源按钮 | 左键 | `wlogout` | ✅ |
| Tray | 由托盘应用决定 | 打开相应后台应用菜单 | ✅ 动态 |

这些点击入口使用的 `kitty`、`pacmixer`、`nmtui`、`s-tui`、`htop`、`nvtop` 和 `wlogout` 都已安装。

### Waybar 当前未生效的入口

- `custom/appmenu` 已经放在左侧模块列表中，但 `modules.jsonc` 没有对应定义，所以当前不会显示，也不能点击启动 Rofi。键盘入口 `Super + R` 仍然正常。
- `custom/media` 依赖 `~/.config/waybar/mediaplayer.py`，但脚本缺失。`playerctl` 已安装，可以作为补回媒体模块时的基础。
- Bluetooth 模块已有 `blueman-manager` 点击命令，但没有加入右侧模块列表，而且 `blueman-manager` 当前未安装。
- `pavucontrol` 已安装，但音频模块现在选择打开 `pacmixer`；配置中只保留了注释形式的 `pavucontrol` 命令。
- MPD 模块已加入 Waybar，`mpd` 软件也已安装，但后台没有运行，所以通常会显示为未连接。
- 电源模式模块缺少 `power-profiles-daemon`；背光和电池模块引用的硬件在当前设备上不存在。

### Wlogout

Waybar 的电源按钮会打开 Wlogout。当前使用系统默认布局：

```text
Wlogout
├── Lock        loginctl lock-session
├── Hibernate   systemctl hibernate
├── Logout      loginctl terminate-user $USER
├── Shutdown    systemctl poweroff
├── Suspend     systemctl suspend
└── Reboot      systemctl reboot
```

Wlogout 目前没有用户级样式配置，仍是系统默认的深色紫色外观，不属于 Catppuccin 配色。

## 常用快捷键

| 快捷键 | 功能 |
| --- | --- |
| `Super + Return` | 打开 Kitty |
| `Super + R` | 打开 Rofi 应用启动器 |
| `Super + E` | 在 Kitty 中打开 Yazi |
| `Super + B` | 打开 Zen Browser |
| `Super + Shift + L` | 启动 Hyprlock |
| `Super + Shift + T` | 打开主题选择器 |
| `Super + Shift + W` | 打开壁纸选择器 |
| `Super + Q` | 关闭窗口 |
| `Super + V` | 切换浮动窗口 |
| `Super + 1..0` | 切换工作区 |
| `Super + Shift + 1..0` | 将窗口移动到工作区 |
| `Super + C` | 显示或隐藏 `magic` 特殊工作区 |
| `Super + Shift + C` | 将窗口移入 `magic` 特殊工作区 |
| `F1` | 使用 Hyprshot 截取整个输出 |
| `Shift + F1` | 使用 Hyprshot 截取区域 |
| `Super + Shift + S` | 使用 Grim、Slurp 和 Satty 截图并标注 |

## 主题与配色

当前配色系统基于 **matugen (Material You)**，从壁纸自动生成主题色：

```text
wallpaper.sh / wallpaper-selector.sh
        │
        ├── awww img (设置壁纸 + 动画过渡)
        │
        └── matugen image (生成 Material You 配色)
                  ↓
            模板输出：
            ├── ~/.config/waybar/colors.css
            ├── ~/.config/rofi/colors.rasi
            ├── ~/.config/kitty/matugen-colors.conf
            ├── ~/.config/hypr/matugen-colors.lua
            └── ~/.config/swaync/colors.css
```

- 换壁纸时自动重新生成所有组件的配色
- Catppuccin Mocha 作为默认 fallback（无壁纸时）
- 预设主题仍可通过 `themes/` 目录和主题选择器使用
- GTK 使用 `catppuccin-mocha-pink-standard+default`
- Qt 使用 Kvantum，并由 `qt6ct` 选择平台主题
- KDE 的安装不会自动让 Hyprland 会话继承 Plasma 的 GTK/Qt 外观设置
- Wlogout 还未统一配色，是当前最明显的主题缺口之一

## 当前待完善项

按影响排序：

1. 安装并启用 `xdg-desktop-portal-hyprland`，恢复原生 Wayland 屏幕共享。
2. 给 `custom/appmenu` 增加定义，让 Waybar 可以点击启动 Rofi。
3. 恢复 `mediaplayer.py`，或改成直接基于 `playerctl` 的媒体模块。
4. 为 Wlogout 添加 Catppuccin 用户级布局和样式。
5. 安装并启用 Hypridle；如果继续使用现有亮度规则，还需要安装 `brightnessctl`。
6. 根据这台设备的实际硬件清理 Waybar 的电池、背光和电源模式模块。
