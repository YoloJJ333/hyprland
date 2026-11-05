hl.config({ plugin = {
  hyprbars = {
    enabled = false,
    bar_color = "rgba(00000090)",
    bar_height = 10,
    bar_blur = true,
    bar_title_enabled = false,
    bar_part_of_window = true,
    bar_precedence_over_border = true,
  },
  hyprcapture = {
    default_mode = "region",
    fullscreen_scope = "current", -- only binds selected monitor
    allow_quick = false,
    fusion_mode = false,
    thumbnail_timeout_ms = 2500,

    -- hdr
    screenshot_mode = "hdr",
    show_hdr_control = true,
    hdr_save_sdr = false,
    hdr_clipboard_format = "sdr",
    hdr_drag_format = "heic",

    -- recording
    record_format = "mp4",
    record_fps = 60,
    record_codec = "auto",
    record_audio = "system",
    record_countdown_seconds = 3,
    record_max_seconds = 0,
  },
}})

hl.plugin.hyprbars.add_button({
  bg_color = "rgb(ff4040)",
  fg_color = "rgb(000000)",
  size = 11,
  icon = "X",
  action = "hyprctl dispatch 'hl.dsp.window.close()'",
})
hl.plugin.hyprbars.add_button({
  bg_color = "rgb(eeee11)",
  fg_color = "rgb(000000)",
  size = 11,
  icon = "O",
  action = [[hyprctl dispatch 'hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" })']],
})
