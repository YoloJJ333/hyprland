local base = os.getenv("HOME") .. "/.config/hypr/hyprland"

return {
  -- apps
  terminal = "kitty",
  launcher = "rofi",
  fileManager = "dolphin",
  browser = "brave",

  -- scripts
  scpt_zoom = base .. "/scripts/zoom.sh",
  scpt_brightness = base .. "/scripts/brightness.sh",

  -- school
  notes = "xournalpp"
}
