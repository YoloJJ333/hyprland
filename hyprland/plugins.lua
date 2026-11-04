hl.config({ plugin = {
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

