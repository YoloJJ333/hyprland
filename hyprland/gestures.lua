local vars = require("hyprland.variables")

-- trackpad
hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace", scale = 5.0 })
hl.gesture({ fingers = 3, direction = "down", action = "special", workspace_name = "scratchpad" })
hl.gesture({ fingers = 3, direction = "up", action = "special", workspace_name = "majic" })

-- tablet mode switch
hl.bind("switch:on:Microsoft Surface KIP Tablet Mode Switch", hl.dsp.exec_cmd([[hyprctl eval 'hl.config({ plugin = { hyprbars = { enabled = true } } })']]), { locked = true })
hl.bind("switch:off:Microsoft Surface KIP Tablet Mode Switch", hl.dsp.exec_cmd([[hyprctl eval 'hl.config({ plugin = { hyprbars = { enabled = false } } })']]), { locked = true })
