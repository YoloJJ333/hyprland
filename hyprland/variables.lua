local base = os.getenv("HOME") .. "/.config/hypr/hyprland"
local script = base .. "/scripts"

return {
  -- apps
  terminal = "kitty",
  launcher = "rofi",
  fileManager = "dolphin",
  browser = "brave",

  -- scripts
  scpt_brightness = script .. "/brightness.sh",
  scpt_copy = script .. "/cliphist.sh",

  -- school
  notes = "xournalpp"
}
