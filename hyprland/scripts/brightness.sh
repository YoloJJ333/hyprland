#!/bin/bash
set -euo pipefail

# Check for arguments
if [ -z "$1" ] || [ -z "$2" ]; then
    echo "Usage: $0 {i|d|s|increase|decrease|set} {0-110}"
    exit 1
fi

ACTION=$1
INPUT=$2

# Input validation
if ! [[ "$INPUT" =~ ^[0-9]+$ ]] || [ "$INPUT" -lt 0 ] || [ "$INPUT" -gt 110 ]; then
    echo "Error: Please provide a percentage between 0 and 110."
    exit 1
fi

# Validate action explicitly before doing math
if [[ ! "$ACTION" =~ ^(i|increase|d|decrease|s|set)$ ]]; then
    echo "Usage: $0 {i|d|s|increase|decrease|set} {0-110}"
    exit 1
fi

# Get current and maximum hardware values
MAX_BRIGHT=$(brightnessctl m)
CUR_BRIGHT=$(brightnessctl g)

# Get current gamma value (extracting just the number, defaulting to 100)
CUR_GAMMA=$(hyprctl hyprsunset gamma 2>/dev/null | grep -oE '[0-9]+' | head -n 1)
if [ -z "$CUR_GAMMA" ]; then
    CUR_GAMMA=100
fi

# AWK Math:
# 1. Reverse the exponential curve using Natural Logarithm (ln) to find current %.
# 2. Add gamma overflow to calculate a "total virtual percentage" (e.g. 110% = max brightness + 200 gamma).
# 3. Add/subtract/set to find the new percentage target.
# 4. Split the target back into brightness (0-100) and gamma (>=100).
# 5. Calculate new raw hardware value using the exponential curve.
AWK_OUTPUT=$(awk -v action="$ACTION" -v input="$INPUT" -v max="$MAX_BRIGHT" -v cur="$CUR_BRIGHT" -v cur_gamma="$CUR_GAMMA" 'BEGIN {
    # 1. Find current perceived percentage (p_cur)
    if (max <= 1 || cur <= 1) {
        p_cur = 0
    } else {
        # Reversed exponential formula: p = 100 * (ln(cur) / ln(max))
        p_cur = 100 * (log(cur) / log(max))
    }

    # 2. Calculate total percentage including gamma overflow
    # Every 10 gamma above 100 counts as 1% of virtual brightness
    total_p_cur = p_cur + ((cur_gamma - 100) / 10)

    # 3. Determine the new total perceived percentage target
    if (action ~ /^(i|increase)$/) {
        total_p_new = total_p_cur + input
    } else if (action ~ /^(d|decrease)$/) {
        total_p_new = total_p_cur - input
    } else if (action ~ /^(s|set)$/) {
        total_p_new = input
    }

    # Clamp the percentage minimum to 0
    if (total_p_new < 0) total_p_new = 0

    # 4. Split back into brightness % and gamma
    if (total_p_new > 100) {
        p_new = 100
        gamma_new = 100 + ((total_p_new - 100) * 10)
    } else {
        p_new = total_p_new
        gamma_new = 100
    }

    # 5. Apply the exponential curve to find the new raw value
    if (p_new == 0) {
        raw_new_float = 1
    } else if (p_new == 100) {
        raw_new_float = max
    } else {
        # Exponential formula: raw = e ^ ((p_new / 100) * ln(max))
        raw_new_float = exp((p_new / 100) * log(max))
    }

    # Round to nearest whole number
    raw_new = int(raw_new_float + 0.5)

    # ANTI-LOCK MECHANISM:
    # Overcome rounding deadzones at the extremely flat bottom/top of the curve.
    if (action ~ /^(i|increase)$/ && raw_new <= cur && cur < max && p_new < 100) {
        raw_new = cur + 1
    } else if (action ~ /^(d|decrease)$/ && raw_new >= cur && cur > 1 && gamma_new == 100 && cur_gamma == 100) {
        raw_new = cur - 1
    }

    # Final sanity clamp to hardware limits
    if (raw_new < 1) raw_new = 1
    if (raw_new > max) raw_new = max

    # Output both values separated by a space
    printf "%.0f %.0f\n", raw_new, gamma_new
}')

# Read the two outputs from awk
read NEW_RAW NEW_GAMMA <<< "$AWK_OUTPUT"

# Apply the change using the absolute raw value
brightnessctl set "${NEW_RAW}" > /dev/null

# Apply the gamma change
hyprctl hyprsunset gamma "${NEW_GAMMA}" > /dev/null

# Output friendly confirmation
case "$ACTION" in
    i|increase) echo "Increased brightness (Raw value: ${NEW_RAW}/${MAX_BRIGHT}, Gamma: ${NEW_GAMMA})" ;;
    d|decrease) echo "Decreased brightness (Raw value: ${NEW_RAW}/${MAX_BRIGHT}, Gamma: ${NEW_GAMMA})" ;;
    s|set)      echo "Set brightness (Raw value: ${NEW_RAW}/${MAX_BRIGHT}, Gamma: ${NEW_GAMMA})" ;;
esac
