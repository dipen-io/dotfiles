#!/bin/bash

# Options for Rofi
options="Sleep\nReboot\nShutdown"

# Show Rofi menu and store selection
choice=$(echo -e $options | rofi -dmenu -i -p "Power Menu")

# Perform action based on choice
case "$choice" in
    Sleep)
        # Suspend using acpi or loginctl (Void uses loginctl too)
        loginctl suspend
        ;;
    Reboot)
        # Reboot via runit
        sudo reboot
        ;;
    Shutdown)
        # Power off via runit
        sudo poweroff
        ;;
    *)
        exit 0
        ;;
esac
