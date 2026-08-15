-- Display rules are evaluated from specific to generic.
hl.monitor({
    output = "HDMI-A-1",
    mode = "3840x2160@120",
    position = "0x0",
    scale = 2,
})

hl.monitor({
    output = "HDMI-A-2",
    mode = "3840x2160@120",
    position = "0x0",
    scale = 2,
    bitdepth = 10,
    vrr = 2,
})

hl.monitor({
    output = "",
    mode = "preferred",
    position = "auto",
    scale = "auto",
})
