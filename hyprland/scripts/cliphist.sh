#!/usr/bin/env bash
# cliphist.sh            -> open the cliphist menu, copy the chosen entry
# cliphist.sh preview .. -> popup the highlighted entry (full text, or the image)
#                           rofi calls this itself via -on-selection-changed

ESCAPE_MARKUP=0   # 1 only if your daemon renders Pango markup (dunst/mako). noctalia: keep 0.
BODY_IMAGE=0      # 1 if your daemon advertises the "body-images" capability (see notes)

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
            img="$tmp.$ext"; mv -f "$tmp" "$img"
            if [ "$BODY_IMAGE" = 1 ]; then
                notify "Clipboard image" "<img src=\"file://$img\" alt=\"clipboard image\"/>" \
                       -h "string:image-path:file://$img" -i "$img"
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
