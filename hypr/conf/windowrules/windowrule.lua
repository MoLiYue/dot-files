hl.window_rule({
    match = { class = "^kitty$" },
    opacity = "0.96 0.96",
    workspace = "1",
})

hl.window_rule({
    match = { class = "^(zen|zen-browser)$" },
    workspace = "2",
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
    match = {
        class = "^(org[.]telegram[.]desktop|telegram-desktop|TelegramDesktop|telegramdesktop|QQ|qq)$",
    },
    workspace = "3",
})

hl.window_rule({
    match = { class = "^(code|Code|code-url-handler)$" },
    workspace = "4",
})

hl.window_rule({
    match = { class = "^(steam|steam_app_[0-9]+)$" },
    workspace = "6",
})
