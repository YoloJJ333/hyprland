local vars = require("hyprland.variables")

hl.window_rule({
  name = "floating-planify",
  match = {
    title = "(?i)^" .. vars.planner .. "$"
  },
  float = true,
  size = { "monitor_w * 0.4", "monitor_h * 0.4" },
  move = {
    "monitor_w * 0.6 - 3",
    "30",
  },
})
