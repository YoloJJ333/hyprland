local base = os.getenv("HOME") .. "/.config/hypr/hyprland"
local script = base .. "/scripts"

return {
  -- system
  screen_lock = "hyprlock",
  -- apps
  terminal = "kitty",
  launcher = "rofi",
  fileManager = "dolphin",
  browser = "brave",

  -- scripts
  scpt_brightness = script .. "/brightness.sh",
  scpt_copy = script .. "/cliphist.sh",
  scpt_lock_scr_wallpaper = script .. "/update-lock-wallpaper.sh",

  -- school
  notes = "xournalpp"
}
