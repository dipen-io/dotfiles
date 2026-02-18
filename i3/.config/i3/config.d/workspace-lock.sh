#!/bin/bash

# Monitor new windows and enforce workspace rules
i3-msg -t subscribe -m '[ "window" ]' | while read -r event; do
    # Check if window was created (new)
    if echo "$event" | grep -q '"change":"new"'; then

        # Get current workspace
        current=$(i3-msg -t get_workspaces | jq -r '.[] | select(.focused==true) | .name')

        # Get window class of newly focused window
        window_class=$(xdotool getactivewindow getwindowclass 2>/dev/null)

        # Rule: Only Alacritty allowed on workspace 1
        if [ "$current" = "1: Coding" ] && [ "$window_class" != "Alacritty" ]; then
            # Move to workspace 2 (Web)
            i3-msg move container to workspace "2: Web"
            notify-send "Workspace Locked" "Only Alacritty allowed on 1: Coding. Moved to 2: Web."
        fi
    fi
done
