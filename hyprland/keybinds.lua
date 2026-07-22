local vars = require("hyprland.variables")

-- apps
  hl.bind("SUPER + RETURN", hl.dsp.exec_cmd(vars.terminal))
  hl.bind("SUPER + T", hl.dsp.exec_cmd(vars.terminal))
  hl.bind("SUPER + SUPER_L", hl.dsp.exec_cmd("pkill " ..vars.launcher.. " || " ..vars.launcher.. " -show combi"), { release = true })
  hl.bind("SUPER + SUPER_R", hl.dsp.exec_cmd("pkill " ..vars.launcher.. " || " ..vars.launcher.. " -show combi"), { release = true })
  hl.bind("SUPER + W", hl.dsp.exec_cmd(vars.browser))
  hl.bind("SUPER + E", hl.dsp.exec_cmd(vars.fileManager))

  -- school
  hl.bind("SUPER + A", hl.dsp.exec_cmd(vars.notes))

-- window
  hl.bind("SUPER + Q", hl.dsp.window.close())
  hl.bind("SUPER + SHIFT + ALT + Q", hl.dsp.exec_cmd("hyprctl kill"))
  
  -- focus
  hl.bind("SUPER + left", hl.dsp.focus({ direction = "l" }))
  hl.bind("SUPER + right", hl.dsp.focus({ direction = "r" }))
  hl.bind("SUPER + up", hl.dsp.focus({ direction = "u" }))
  hl.bind("SUPER + down", hl.dsp.focus({ direction = "d" }))

  -- goto
  for i = 1, 9 do
    hl.bind("SUPER + ".. i, hl.dsp.focus({ workspace = i }))
  end
  hl.bind("SUPER + 0", hl.dsp.focus({ workspace = 10 }))
  hl.bind("SUPER + S", hl.dsp.workspace.toggle_special(""))
  hl.bind("SUPER + CTRL + left", hl.dsp.focus({ workspace = "-1" }))
  hl.bind("SUPER + CTRL + right", hl.dsp.focus({ workspace = "+1" }))
  
  -- moveto
  hl.bind("SUPER + SHIFT + left", hl.dsp.window.move({ direction = "l" }))
  hl.bind("SUPER + SHIFT + right", hl.dsp.window.move({ direction = "r" }))
  hl.bind("SUPER + SHIFT + up", hl.dsp.window.move({ direction = "u" }))
  hl.bind("SUPER + SHIFT + down", hl.dsp.window.move({ direction = "d" }))
  hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true })
  
  for i = 1, 9 do
    hl.bind("SUPER + SHIFT + ".. i, hl.dsp.window.move({ workspace = i }))
  end
  hl.bind("SUPER + SHIFT + 0", hl.dsp.window.move({ workspace = 10 }))
  hl.bind("SUPER + SHIFT + S", hl.dsp.window.move({ workspace = "special" }))
  hl.bind("SUPER + CTRL + SHIFT + left", hl.dsp.window.move({ workspace = "-1" }))
  hl.bind("SUPER + CTRL + SHIFT + right", hl.dsp.window.move({ workspace = "+1" }))

  -- modify
  hl.bind("SUPER + semicolon", hl.dsp.layout("splitratio -0.1"), { repeating = true })
  hl.bind("SUPER + apostrophe", hl.dsp.layout("splitratio +0.1"), { repeating = true })
  hl.bind("SUPER + ALT + space", hl.dsp.window.float({ action = "toggle" }))
  hl.bind("SUPER + D", hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" })) -- Maximize
  hl.bind("SUPER + F", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" })) -- Fullscreen
  hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true })
  -- shrink window
  hl.bind("CTRL + SUPER + backslash", hl.dsp.exec_cmd("hyprctl dispatch resizeactive exact 640 480"))

-- utility
  -- audio
  hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })
  hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 1%+"), { repeating = true, locked = true })
  hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%-"), { repeating = true, locked = true })
  hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
  hl.bind("XF86AudioStop", hl.dsp.exec_cmd("playerctl stop"), { locked = true })
  hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next || playerctl position $(playerctl metadata mpris:length) | awk '{ print $1 / 1000000 }'"), { locked = true })
  hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
  
  -- brightness
  hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd(vars.scpt_brightness.. " i 1"), { repeating = true, locked = true })
  hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd(vars.scpt_brightness.. " d 1"), { repeating = true, locked = true })
  hl.bind("SUPER + XF86MonBrightnessUp", hl.dsp.exec_cmd(vars.scpt_brightness.. " s 88"), { locked = true })
  hl.bind("SUPER + XF86MonBrightnessDown", hl.dsp.exec_cmd(vars.scpt_brightness.. " s 88"), { locked = true })
  hl.bind("CTRL + XF86MonBrightnessUp", hl.dsp.exec_cmd("hyprctl hyprsunset temperature +100"), { repeating = true, locked = true })
  hl.bind("CTRL + XF86MonBrightnessDown", hl.dsp.exec_cmd("hyprctl hyprsunset temperature -100"), { repeating = true, locked = true })
  hl.bind("SUPER + CTRL + XF86MonBrightnessUp", hl.dsp.exec_cmd("hyprctl hyprsunset temperature 6500"), { repeating = true, locked = true })
  hl.bind("SUPER + CTRL + XF86MonBrightnessDown", hl.dsp.exec_cmd("hyprctl hyprsunset temperature 6500"), { repeating = true, locked = true })

  -- screenshot
  hl.bind("PRINT", hl.dsp.exec_cmd("hyprshot --z -t 2500 --clipboard-only -m region"))
  hl.bind("CTRL + PRINT", hl.dsp.exec_cmd("hyprshot -z -t 2500 -m region"))
  hl.bind("SHIFT + PRINT", hl.dsp.exec_cmd("hyprshot -z -t 2500 --clipboard-only -m window"))
  hl.bind("CTRL + SHIFT + PRINT", hl.dsp.exec_cmd("hyprshot -z -t 2500 -m window"))
  hl.bind("SUPER + PRINT", hl.dsp.exec_cmd("hyprshot -z -t 2500 --clipboard-only -m active -m output"))
  hl.bind("SUPER + CTRL + PRINT", hl.dsp.exec_cmd("hyprshot -z -t 2500 -m active -m output"))

  -- zoom
  hl.bind("SUPER + minus", function() hl.config({ cursor = { zoom_factor = math.max(1.0, hl.get_config("cursor.zoom_factor") * 0.9) } }) end, { repeating = true })
  hl.bind("SUPER + equal", function() hl.config({ cursor = { zoom_factor = math.min(5.0, hl.get_config("cursor.zoom_factor") * 1.1) } }) end, { repeating = true })
  hl.bind("SUPER + BackSpace", function() hl.config({ cursor = { zoom_factor = 1.0 } }) end)

  -- clipboard
  hl.bind("SUPER + V", hl.dsp.exec_cmd("cliphist list | rofi -dmenu -display-columns 2 | cliphist decode | wl-copy"))
