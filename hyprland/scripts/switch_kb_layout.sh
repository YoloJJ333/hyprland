#!/bin/bash

# 1. Advance Hyprland's layout for all keyboards (seat/Rofi)
hyprctl switchxkblayout all next

# Small pause (10ms) to ensure Hyprland updates its internal state table
sleep 0.01

# 2. Query Hyprland's main active keymap
ACTIVE_MAP=$(hyprctl devices -j | jq -r '.keyboards[] | select(.main == true) | .active_keymap')

# Fallback: if no keyboard is marked 'main', pick the first physical keyboard
if [ -z "$ACTIVE_MAP" ] || [ "$ACTIVE_MAP" = "null" ]; then
    ACTIVE_MAP=$(hyprctl devices -j | jq -r '.keyboards[0].active_keymap')
fi

# 3. Force IBus to match Hyprland's active keymap
case "$ACTIVE_MAP" in
    *"Colemak"*|*"colemak"*)
        ibus engine "xkb:us:colemak_dh:eng"
        ;;
    *)
        ibus engine "xkb:us::eng"
        ;;
esac
