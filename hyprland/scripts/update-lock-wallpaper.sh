#!/usr/bin/env bash
set -euo pipefail

WALLPAPER_PATH="$HOME/.cache/hyprlock"

wallpaper="$(
    hyprctl hyprpaper listactive |
        head -n 1 |
        sed 's/^[^:]*: //'
)"

[ -n "$wallpaper" ] && [ -f "$wallpaper" ] || exit 1

mkdir -p $WALLPAPER_PATH
ln -sfn "$wallpaper" "$WALLPAPER_PATH/current-wallpaper"
