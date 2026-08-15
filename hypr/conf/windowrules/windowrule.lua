hl.window_rule({
    match = { class = "kitty" },
    opacity = "0.96 0.96",
})

hl.window_rule({
    match = { class = "fcitx" },
    pseudo = true,
})

hl.window_rule({
    match = { title = ".*feh.*" },
    workspace = "10",
})

hl.window_rule({
    match = { class = ".*telegram.*" },
    workspace = "3",
})
