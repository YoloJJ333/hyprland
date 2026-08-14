#!/usr/bin/env bash
# cliphist.sh            -> open the cliphist menu, copy the chosen entry
# cliphist.sh preview .. -> popup the highlighted entry (full text, or the image)
#                           rofi calls this itself via -on-selection-changed
#
# Tuned for swaync (advertises body-markup + body-images).
# On a daemon without those (noctalia, mako, dunst), set both toggles to 0.

ESCAPE_MARKUP=1   # swaync renders Pango markup, so escape & < > in copied text
BODY_IMAGE=1      # swaync renders <img> inside the body, not just as a corner icon

sync_hint=string:x-canonical-private-synchronous:cliphist

# strip shell-quote chars so rofi can always parse {entry} (id + tab preserved)
sanitize() { sed -e "s/'/’/g" -e 's/"/”/g' -e 's/\\/⧵/g'; }
esc() { if [ "$ESCAPE_MARKUP" = 1 ]; then sed 's/&/\&amp;/g; s/</\&lt;/g; s/>/\&gt;/g'; else cat; fi; }

notify() {
    local summary=$1 body=$2; shift 2
    case $body in -*) body=" $body" ;; esac
    notify-send -a cliphist -t 4000 -h "$sync_hint" "$@" "$summary" "$body"
}

if [ "$1" = "preview" ]; then
    shift
    entry="$*"
    [ -z "$entry" ] && exit 0

    mkdir -p /tmp/cliphist-preview
    tmp=/tmp/cliphist-preview/current

    id="${entry%%[!0-9]*}"
    printf '%s\t' "$id" | cliphist decode > "$tmp" 2>/dev/null
    if [ ! -s "$tmp" ]; then     # fallback: match the sanitized row back to its id
        id=$(cliphist list | sanitize | grep -Fm1 -- "$entry" | cut -f1)
        [ -n "$id" ] && printf '%s\t' "$id" | cliphist decode > "$tmp" 2>/dev/null
    fi

    body=
    if [ -s "$tmp" ]; then
        sig=$(head -c 4 "$tmp" | od -An -tx1 | tr -d ' \n')
        ext=
        case "$sig" in
            89504e47) ext=png ;; ffd8ff??) ext=jpg ;; 47494638) ext=gif ;;
            424d????) ext=bmp ;; 52494646) ext=webp ;;
        esac
        if [ -n "$ext" ]; then
            # unique filename per id: a single reused path can get cached, which
            # would keep redisplaying the first image you highlighted
            img="/tmp/cliphist-preview/$id.$ext"; mv -f "$tmp" "$img"
            if [ "$BODY_IMAGE" = 1 ]; then
                # swaync pulls the <img> tag out of the body and renders it inline
                notify "Clipboard image" "<img src=\"file://$img\" alt=\"clipboard\"/>"
            else
                notify "Clipboard image" "${ext^^} · press Enter to copy" \
                       -h "string:image-path:file://$img" -i "$img"
            fi
            exit 0
        fi
        body=$(head -c 2000 "$tmp" | esc)
    fi

    [ -z "$body" ] && body=$(printf '%s' "$entry" | esc)
    notify "Clipboard preview" "$body"
    exit 0
fi

# --- default: open the menu (list sanitized so rofi can parse every row) ---
cliphist list | sanitize | rofi -dmenu -display-columns 2 \
  -theme-str 'window {width: 60%;} listview {lines: 12;}' \
  -on-selection-changed "$0 preview '{entry}'" \
  | cut -f1 | tr -d '\n' | cliphist decode | wl-copy
