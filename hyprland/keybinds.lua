local vars = require("hyprland.variables")

-- system
  hl.bind("SUPER + L", hl.dsp.exec_cmd(vars.scpt_lock_scr_wallpaper .. " ; " .. vars.screen_lock))
  hl.bind("SUPER + CTRL + L", hl.dsp.exec_cmd("qs -c " .. vars.qs_config .. " ipc call session open"))
  hl.bind("ALT + space", hl.dsp.exec_cmd(vars.scpt_kb_layout), { locked = true })

-- apps
  hl.bind("SUPER + RETURN", hl.dsp.exec_cmd(vars.terminal))
  hl.bind("SUPER + T", hl.dsp.exec_cmd(vars.terminal))
  hl.bind("SUPER + SUPER_L", hl.dsp.exec_cmd("pkill " .. vars.launcher .. " || " .. vars.launcher .. " -show combi"), { release = true })
  hl.bind("SUPER + SUPER_R", hl.dsp.exec_cmd("pkill " .. vars.launcher .. " || " .. vars.launcher .. " -show combi"), { release = true })
  hl.bind("SUPER + W", hl.dsp.exec_cmd(vars.browser))
  hl.bind("SUPER + E", hl.dsp.exec_cmd(vars.fileManager))
  hl.bind("SUPER + P", hl.dsp.exec_cmd(vars.planner))

  -- school
  hl.bind("SUPER + A", hl.dsp.exec_cmd(vars.notes))

-- window
  hl.bind("SUPER + Q", hl.dsp.window.close())
  hl.bind("SUPER + CTRL + ALT + Q", hl.dsp.exec_cmd("hyprctl kill"))
  
  -- focus
  hl.bind("SUPER + left", hl.dsp.focus({ direction = "l" }))
  hl.bind("SUPER + right", hl.dsp.focus({ direction = "r" }))
  hl.bind("SUPER + up", hl.dsp.focus({ direction = "u" }))
  hl.bind("SUPER + down", hl.dsp.focus({ direction = "d" }))

  -- goto
  for i = 1, 10 do
    hl.bind("SUPER + " .. i % 10, hl.dsp.focus({ workspace = i }))
  end
  hl.bind("SUPER + S", hl.dsp.workspace.toggle_special("scratchpad"))
  hl.bind("SUPER + CTRL + S", hl.dsp.workspace.toggle_special("majic"))
  hl.bind("SUPER + CTRL + left", hl.dsp.focus({ workspace = "-1" }))
  hl.bind("SUPER + CTRL + right", hl.dsp.focus({ workspace = "+1" }))
  hl.bind("SHIFT + ALT + tab", hl.dsp.focus({ workspace = "-1" }))
  hl.bind("ALT + tab", hl.dsp.focus({ workspace = "+1" }))
  
  -- moveto
  for i = 1, 10 do
    hl.bind("SUPER + SHIFT + " .. i % 10, hl.dsp.window.move({ workspace = i }))
  end
  hl.bind("SUPER + SHIFT + S", hl.dsp.window.move({ workspace = "special:scratchpad" }))
  hl.bind("SUPER + CTRL + SHIFT + S", hl.dsp.window.move({ workspace = "special:majic" }))
  hl.bind("SUPER + CTRL + SHIFT + left", hl.dsp.window.move({ workspace = "-1" }))
  hl.bind("SUPER + CTRL + SHIFT + right", hl.dsp.window.move({ workspace = "+1" }))

  -- organize
  hl.bind("SUPER + SHIFT + left", hl.dsp.window.move({ direction = "l" }))
  hl.bind("SUPER + SHIFT + right", hl.dsp.window.move({ direction = "r" }))
  hl.bind("SUPER + SHIFT + up", hl.dsp.window.move({ direction = "u" }))
  hl.bind("SUPER + SHIFT + down", hl.dsp.window.move({ direction = "d" }))
  hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true })
  
  -- modify
  hl.bind("SUPER + semicolon", hl.dsp.layout("splitratio -0.1"), { repeating = true })
  hl.bind("SUPER + apostrophe", hl.dsp.layout("splitratio +0.1"), { repeating = true })
  hl.bind("SUPER + ALT + space", hl.dsp.window.float({ action = "toggle" }))
  hl.bind("SUPER + D", hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" }))
  hl.bind("SUPER + F", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))
  hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true })
  -- shrink window
  hl.bind("SUPER + CTRL + backslash", hl.dsp.exec_cmd("hyprctl dispatch resizeactive exact 640 480"))

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
  hl.bind("SUPER + XF86MonBrightnessUp", hl.dsp.exec_cmd(vars.scpt_brightness.. " s 88"), { locked = true, locked = true })
  hl.bind("SUPER + XF86MonBrightnessDown", hl.dsp.exec_cmd(vars.scpt_brightness.. " s 88"), { locked = true, locked = true })
  hl.bind("CTRL + XF86MonBrightnessUp", hl.dsp.exec_cmd("hyprctl hyprsunset temperature +100"), { repeating = true, locked = true })
  hl.bind("CTRL + XF86MonBrightnessDown", hl.dsp.exec_cmd("hyprctl hyprsunset temperature -100"), { repeating = true, locked = true })
  hl.bind("SUPER + CTRL + XF86MonBrightnessUp", hl.dsp.exec_cmd("hyprctl hyprsunset temperature 6500"), { repeating = true, locked = true })
  hl.bind("SUPER + CTRL + XF86MonBrightnessDown", hl.dsp.exec_cmd("hyprctl hyprsunset temperature 6500"), { repeating = true, locked = true })

  -- screenshot
  local copy_only = { save = false, clipboard = true }
  local save_copy = { save = true, clipboard = true }
  local function hyprcapture() return hl.plugin.hyprcapture end

    -- region
    hl.bind("PRINT", function() hyprcapture().open("region", copy_only) end)
    hl.bind("CTRL + PRINT", function() hyprcapture().open("region", save_copy) end)
    hl.bind("ALT + PRINT", function() hyprcapture().open_editor("region", copy_only) end)
    hl.bind("CTRL + ALT + PRINT", function() hyprcapture().open_editor("region", save_copy) end)
    hl.bind("PRINT + R", function() hyprcapture().record_toggle("region") end)

    -- window
    hl.bind("SHIFT + PRINT", function() hyprcapture().open("window", copy_only) end)
    hl.bind("CTRL + SHIFT + PRINT", function() hyprcapture().open("window", save_copy) end)
    hl.bind("SHIFT + ALT + PRINT", function() hyprcapture().open_editor("window", copy_only) end)
    hl.bind("CTRL + SHIFT + ALT + PRINT", function() hyprcapture().open_editor("window", save_copy) end)
    hl.bind("SHIFT + PRINT + R", function() hyprcapture().record_toggle("window") end)

    -- monitor
    hl.bind("SUPER + PRINT", function() hyprcapture().open("fullscreen", copy_only) end)
    hl.bind("SUPER + CTRL + PRINT", function() hyprcapture().open("fullscreen", save_copy) end)
    hl.bind("SUPER + ALT + PRINT", function() hyprcapture().open_editor("fullscreen", copy_only) end)
    hl.bind("SUPER + CTRL + ALT + PRINT", function() hyprcapture().open_editor("fullscreen", save_copy) end)
    hl.bind("SUPER + PRINT + R", function() hyprcapture().record_toggle("fullscreen") end)

  -- zoom
  hl.bind("SUPER + minus", function() hl.config({ cursor = { zoom_factor = math.max(1.0, hl.get_config("cursor.zoom_factor") * 0.9) } }) end, { repeating = true, locked = true })
  hl.bind("SUPER + equal", function() hl.config({ cursor = { zoom_factor = math.min(5.0, hl.get_config("cursor.zoom_factor") * 1.1) } }) end, { repeating = true, locked = true })
  hl.bind("SUPER + BackSpace", function() hl.config({ cursor = { zoom_factor = 1.0 } }) end, { locked = true })

  -- clipboard
  hl.bind("SUPER + V", hl.dsp.exec_cmd(vars.scpt_copy))
