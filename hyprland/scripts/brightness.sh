#!/usr/bin/env bash
set -euo pipefail

# Check if at least one argument is provided
if [ -z "${1:-}" ]; then
    echo "Usage: $0 {i|d|s|increase|decrease|set} {0-110}"
    echo "       $0 {g|get}"
    exit 1
fi

ACTION=$1

# Get current and maximum hardware values (required by all commands)
MAX_BRIGHT=$(brightnessctl m)
CUR_BRIGHT=$(brightnessctl g)

# Get current gamma value (extracting just the number, defaulting to 100)
CUR_GAMMA=$(hyprctl hyprsunset gamma 2>/dev/null | grep -oE '[0-9]+' | head -n 1)
if [ -z "$CUR_GAMMA" ]; then
    CUR_GAMMA=100
fi

# Intercept 'get' command before requiring a second argument
if [[ "$ACTION" =~ ^(g|get)$ ]]; then
    CUR_PCT=$(awk -v max="$MAX_BRIGHT" -v cur="$CUR_BRIGHT" -v cur_gamma="$CUR_GAMMA" 'BEGIN {
        if (cur_gamma > 100) {
            total_p = 100 + int(((cur_gamma - 100) / 10) + 0.5)
        } else if (max <= 1 || cur <= 1) {
            total_p = 0
        } else if (cur >= max) {
            total_p = 100
        } else {
            # Inverse cubic power curve: p = 100 * cbrt(cur / max)
            total_p = int((100 * ((cur / max) ^ (1.0/3.0))) + 0.5)
        }
        if (total_p < 0) total_p = 0
        if (total_p > 110) total_p = 110
        printf "%d\n", total_p
    }')
    
    echo "Current Brightness: ${CUR_PCT}% (Raw: ${CUR_BRIGHT}/${MAX_BRIGHT}, Gamma: ${CUR_GAMMA})"
    exit 0
fi

# For all other commands, a second argument is strictly required
if [ -z "${2:-}" ]; then
    echo "Error: Missing percentage argument."
    echo "Usage: $0 {i|d|s|increase|decrease|set} {0-110}"
    exit 1
fi

INPUT=$2

# Input validation
if ! [[ "$INPUT" =~ ^[0-9]+$ ]] || [ "$INPUT" -lt 0 ] || [ "$INPUT" -gt 110 ]; then
    echo "Error: Please provide a percentage between 0 and 110."
    exit 1
fi

# Validate action explicitly before doing math
if [[ ! "$ACTION" =~ ^(i|increase|d|decrease|s|set)$ ]]; then
    echo "Error: Invalid action."
    echo "Usage: $0 {i|d|s|increase|decrease|set} {0-110}"
    echo "       $0 {g|get}"
    exit 1
fi

# AWK Math:
# 1. Discretize current state into a strict integer percentage [0, 110].
# 2. Add/subtract/set target percentage.
# 3. Hard clamp target to [0, 110].
# 4. Split target into brightness (0-100%) and gamma (100-200).
# 5. Compute raw brightness value using a cubic power curve.
AWK_OUTPUT=$(awk -v action="$ACTION" -v input="$INPUT" -v max="$MAX_BRIGHT" -v cur="$CUR_BRIGHT" -v cur_gamma="$CUR_GAMMA" 'BEGIN {
    # 1. Determine current strictly integer total percentage
    if (cur_gamma > 100) {
        total_p_cur = 100 + int(((cur_gamma - 100) / 10) + 0.5)
    } else if (max <= 1 || cur <= 1) {
        total_p_cur = 0
    } else if (cur >= max) {
        total_p_cur = 100
    } else {
        # Inverse cubic power curve: p = 100 * cbrt(cur / max)
        total_p_cur = int((100 * ((cur / max) ^ (1.0/3.0))) + 0.5)
    }

    # 2. Determine target total percentage
    if (action ~ /^(i|increase)$/) {
        total_p_new = total_p_cur + input
    } else if (action ~ /^(d|decrease)$/) {
        total_p_new = total_p_cur - input
    } else if (action ~ /^(s|set)$/) {
        total_p_new = input
    }

    # 3. Hard clamp total percentage to [0, 110]
    if (total_p_new < 0) total_p_new = 0
    if (total_p_new > 110) total_p_new = 110

    # 4. Split into brightness percentage (0-100) and gamma (100-200)
    if (total_p_new > 100) {
        p_new = 100
        gamma_new = 100 + ((total_p_new - 100) * 10)
    } else {
        p_new = total_p_new
        gamma_new = 100
    }

    # 5. Calculate new raw hardware brightness
    if (p_new == 0) {
        raw_new = 1
    } else if (p_new == 100) {
        raw_new = max
    } else {
        # Cubic power curve: raw = max * (p / 100)^3
        raw_new_float = max * ((p_new / 100) ^ 3.0)
        raw_new = int(raw_new_float + 0.5)
    }

    # ANTI-LOCK MECHANISM:
    # Overcome rounding deadzones at the extremely flat bottom of the cubic curve.
    if (action ~ /^(i|increase)$/ && raw_new <= cur && cur < max && p_new < 100) {
        raw_new = cur + 1
    } else if (action ~ /^(d|decrease)$/ && raw_new >= cur && cur > 1 && gamma_new == 100 && cur_gamma == 100) {
        raw_new = cur - 1
    }

    # Clamp raw brightness to hardware limits
    if (raw_new < 1) raw_new = 1
    if (raw_new > max) raw_new = max

    printf "%d %d\n", raw_new, gamma_new
}')

# Read the two outputs from awk
read -r NEW_RAW NEW_GAMMA <<< "$AWK_OUTPUT"

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
