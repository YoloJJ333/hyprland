local vars = require("hyprland.variables")

hl.on("hyprland.start", function()
    hl.exec_cmd("qs -c noctalia-shell")
    hl.exec_cmd("systemctl --user start hyprpolkitagent") -- required without uwsm
    hl.exec_cmd("hyprpm reload")
    hl.exec_cmd("iio-hyprland")
    hl.exec_cmd("hyprsunset")
    hl.exec_cmd("ibus start")
    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")
    hl.exec_cmd("wl-clip-persist --clipboard regular")
end)
