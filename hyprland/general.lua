-- general.lua

-- monitors
-- https://wiki.hypr.land/Configuring/Basics/Monitors/
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1.5 })

hl.config({
  general = {
    gaps_in = 1, -- temporary
    gaps_out = 5, 1, 1, 1, -- temporary | top, right, bottom, left
    border_size = 1,
    resize_on_border = true,
    col = {
      active_border = {
        colors = { "#ff0000", "#ffff00", "#00ff00", "#00ffff", "#0000ff", "#ff00ff" },
        angle = 0,
      },
    },
  },

  -- https://wiki.hypr.land/Configuring/Basics/Variables/#animations
  animations = {
    enabled = true, -- yes, please :)

    -- Default curves, see https://wiki.hypr.land/Configuring/Animations/#curves
    -- NAME,           X0,   Y0,   X1,   Y1
    bezier = {
      "easeOutQuint,   0.23, 1,    0.32, 1",
      "easeInOutCubic, 0.65, 0.05, 0.36, 1",
      "linear,         0,    0,    1,    1",
      "almostLinear,   0.5,  0.5,  0.75, 1",
      "quick,          0.15, 0,    0.1,  1"
    },

    -- Default animations, see https://wiki.hypr.land/Configuring/Animations/
    -- NAME,          ONOFF, SPEED, CURVE,        [STYLE]
    animation = {
      "global,        1,     10,    default",
      "border,        1,     5.39,  easeOutQuint",
      "windows,       1,     4.79,  easeOutQuint",
      "windowsIn,     1,     4.1,   easeOutQuint, popin 87%",
      "windowsOut,    1,     1.49,  linear,       popin 87%",
      "fadeIn,        1,     1.73,  almostLinear",
      "fadeOut,       1,     1.46,  almostLinear",
      "fade,          1,     3.03,  quick",
      "layers,        1,     3.81,  easeOutQuint",
      "layersIn,      1,     4,     easeOutQuint, fade",
      "layersOut,     1,     1.5,   linear,       fade",
      "fadeLayersIn,  1,     1.79,  almostLinear",
      "fadeLayersOut, 1,     1.39,  almostLinear",
      "workspaces,    1,     1.94,  almostLinear, fade",
      "workspacesIn,  1,     1.21,  almostLinear, fade",
      "workspacesOut, 1,     1.94,  almostLinear, fade",
      "zoomFactor,    1,     7,     quick",
      "specialWorkspace, 1, 6, almostLinear, slidevert"
    }
  },

  dwindle = {
    preserve_split = true
  },

  input = {
    kb_layout = "us,us",
    kb_variant = ",colemak_dh",
    kb_model = "microsoftsurface",

    numlock_by_default = true,
    repeat_delay = 300,
    repeat_rate = 40,

    touchpad = {
      natural_scroll = true,
      clickfinger_behavior = true
    }
  },

  xwayland = {
    force_zero_scaling = true
  },
})

hl.curve("border_linear", {
  type = "bezier",
  points = { { 0, 0 }, { 1, 1 } },
})

local border_rotation_enabled = false
local function apply_border_rotation()
  hl.animation({
    leaf = "borderangle",
    enabled = border_rotation_enabled,
    speed = 80,
    bezier = "border_linear",
    style = border_rotation_enabled and "loop" or "once",
  })
end

apply_border_rotation()

hl.bind("SUPER + R", function()
  border_rotation_enabled = not border_rotation_enabled
  apply_border_rotation()
end)
