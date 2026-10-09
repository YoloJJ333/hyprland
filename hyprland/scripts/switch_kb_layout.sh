#!/usr/bin/env bash

hyprctl switchxkblayout all next

CURRENT=$(ibus engine)

if [ "$CURRENT" = "xkb:us::eng" ]; then
    ibus engine "xkb:us:colemak_dh:eng"
else
    ibus engine "xkb:us::eng"
fi
