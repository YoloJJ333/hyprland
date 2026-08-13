local vars = require("hyprland.variables")

hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace", scale = 5.0 })
hl.gesture({ fingers = 3, direction = "down", action = "special", workspace_name = "scratchpad" })
hl.gesture({ fingers = 3, direction = "up", action = "special", workspace_name = "majic" })
