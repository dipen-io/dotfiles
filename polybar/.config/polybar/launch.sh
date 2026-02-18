#!/bin/bash

# Use ~/.config/polybar directly
POLYBAR_DIR="$HOME/.config/polybar"
export POLYBAR_COLLECTION="$POLYBAR_DIR"

# Auto-detect network interfaces
export POLYBAR_WIRELESS=$(ip link show | grep -E '^[0-9]+: wl' | awk '{print $2}' | sed 's/://' | head -1)
export POLYBAR_WIRED=$(ip link show | grep -E '^[0-9]+: en|^[[0-9]+: eth' | awk '{print $2}' | sed 's/://' | head -1)

# Auto-detect battery (if exists)
if [ -d /sys/class/power_supply ]; then
    export POLYBAR_BATTERY_ADP=$(ls /sys/class/power_supply/ | grep -E '^ADP|^AC' | head -1)
    export POLYBAR_BATTERY_BAT=$(ls /sys/class/power_supply/ | grep -E '^BAT' | head -1)
fi

# Kill existing polybar
killall -q polybar
while pgrep -x polybar >/dev/null; do sleep 0.1; done

# Launch
polybar -c "$POLYBAR_DIR/config.ini" main &
# polybar -c "$POLYBAR_DIR/std_config.ini" example &
