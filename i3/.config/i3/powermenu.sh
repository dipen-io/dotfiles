#!/bin/bash

# Options for Rofi
options="Sleep\nReboot\nShutdown\nLogout"

# Show Rofi menu and store selection
choice=$(echo -e $options | rofi -dmenu -i -p "Power Menu")

# Perform action based on choice
case "$choice" in
    Sleep)
        loginctl suspend
        ;;
    Reboot)
        sudo reboot
        ;;
    Shutdown)
        sudo poweroff
        ;;
    Logout)
        # Adjust the command depending on your DE / WM
        i3-msg exit      # For i3
        # gnome-session-quit --logout --no-prompt  # For GNOME
        # xfce4-session-logout --logout            # For XFCE
        # pkill -KILL -u $USER                     # Generic fallback
        ;;
    *)
        exit 0
        ;;
esac

