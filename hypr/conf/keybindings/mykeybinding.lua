local terminal = "kitty"
local fileManager = [[kitty zsh -c "source ~/.zshrc && yazi"]]
local menu = "rofi -show drun"
local browser = "zen-browser"
local picture = "feh --fullscreen --borderless --zoom fill --auto-zoom --scale-down --hide-pointer"
local mainMod = "SUPER"

hl.bind(mainMod .. " + M", hl.dsp.exec_cmd(
    "command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch exit"
))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd(picture))
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.exec_cmd("hyprlock"))

-- Theme selector.
hl.bind(mainMod .. " + SHIFT + T", hl.dsp.exec_cmd("~/.config/scripts/theme-selector.sh"))

-- Move focus with mainMod + arrow keys.
hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))

-- Switch workspaces and move windows with mainMod + [0-9].
for i = 1, 10 do
    local key = i % 10
    hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Scroll through existing workspaces.
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Move and resize windows with mainMod + mouse drag.
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + Q", hl.dsp.window.close())

-- Screenshots.
hl.bind("F1", hl.dsp.exec_cmd("hyprshot -m output"))
hl.bind("SHIFT + F1", hl.dsp.exec_cmd("hyprshot -m region"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd([[grim -g "$(slurp)" - | satty --filename -]]))

-- Move focus with mainMod + hjkl.
hl.bind(mainMod .. " + h", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + l", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + k", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + j", hl.dsp.focus({ direction = "down" }))

hl.bind(mainMod .. " + MINUS", hl.dsp.layout("togglesplit"))

-- Special workspace (scratchpad).
hl.bind(mainMod .. " + C", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + C", hl.dsp.window.move({ workspace = "special:magic" }))
