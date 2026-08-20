-- Hyprland configuration for 0.56+.
-- The modules below mirror the previous Hyprlang source layout.

local config_home = os.getenv("XDG_CONFIG_HOME") or (os.getenv("HOME") .. "/.config")
local active_theme = config_home .. "/theme-current/hyprland.lua"
local default_theme = config_home .. "/themes/catppuccin-mocha/apps/hyprland.lua"
local loaded, colors = pcall(dofile, active_theme)
if not loaded then
    colors = dofile(default_theme)
end

require("conf/monitors/monitor")
require("conf/autostart")
require("conf/environments/default")
require("conf/inputdevice")
require("conf/workspaces/workspaces")
require("conf/keybindings/mykeybinding")
require("conf/windowrules/windowrule")
require("conf/animations/default")

hl.config({
    general = {
        gaps_in = 5,
        gaps_out = 20,
        border_size = 2,
        col = {
            active_border = {
                colors = colors.active_border,
            },
            inactive_border = colors.inactive_border,
        },
        layout = "dwindle",
        allow_tearing = false,
    },

    decoration = {
        rounding = 10,
        blur = {
            enabled = true,
            size = 3,
            passes = 1,
        },
        shadow = {
            enabled = true,
            range = 4,
            render_power = 3,
            color = 0xee1a1a1a,
        },
    },

    dwindle = {
        preserve_split = true,
    },

    xwayland = {
        force_zero_scaling = true,
    },

    misc = {
        force_default_wallpaper = -1,
    },
})

-- Trackpad gestures.
hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })
hl.gesture({ fingers = 4, direction = "pinchin", action = "special", workspace_name = "magic" })
hl.gesture({ fingers = 4, direction = "pinchout", action = "special", workspace_name = "magic" })
hl.gesture({ fingers = 3, direction = "up", action = "float" })
hl.gesture({ fingers = 3, direction = "down", mods = "SUPER", action = "fullscreen" })
hl.gesture({ fingers = 4, direction = "left", mods = "SUPER", action = "close" })
hl.gesture({ fingers = 4, direction = "right", action = "move" })
hl.gesture({ fingers = 4, direction = "up", action = "resize" })

hl.device({
    name = "epic-mouse-v1",
    sensitivity = -0.5,
})

-- Toolkit and application defaults. The last QT_QPA_PLATFORMTHEME value
-- intentionally matches the effective value from the previous config.
hl.env("GTK_THEME", "catppuccin-mocha-pink-standard+default")
hl.env("GDK_SCALE", "2")
hl.env("QT_STYLE_OVERRIDE", "kvantum")
hl.env("QT_QPA_PLATFORMTHEME", "qt5ct")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "wayland")
