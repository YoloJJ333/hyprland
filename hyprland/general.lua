-- general.lua

-- monitors
-- https://wiki.hypr.land/Configuring/Monitors/
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1.5 })

hl.config({
  general = {
    gaps_in = 1, -- temporary
    gaps_out = 5, 1, 1, 1, -- temporary | top, right, bottom, left
    border_size = 1,
    resize_on_border = true
  },

  -- https://wiki.hypr.land/Configuring/Variables/#animations
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
      "zoomFactor,    1,     7,     quick"
    }
  },

  dwindle = {
    preserve_split = true
  },

  input = {
    kb_layout = "us,us",
    kb_variant = ",colemak_dh",
    kb_model = "microsoftsurface",
    kb_options = "grp:alt_shift_toggle",

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
hl.config({
  plugin = {
    hyprbars = {
      bar_height = 10,
      ["col.text"] = "rgba(ffffffff)",
      bar_text_size = 7,
      bar_text_font = "Courier New Bold",
      bar_precedence_over_border = true,
    }
  }
})

-- Registering buttons directly via Lua [6, 2]
hl.plugin.hyprbars.add_button({
  bg_color = "rgb(ff4040)",
  fg_color = "rgb(ffffff)",
  size = 8,
  icon = "X",
  action = "hyprctl dispatch killactive",
})

hl.plugin.hyprbars.add_button({
  bg_color = "rgb(eeee11)",
  fg_color = "rgb(000000)",
  size = 8,
  icon = "O",
  action = "hyprctl dispatch fullscreen 1",
})
