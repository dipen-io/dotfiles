#!/bin/bash

WALL_DIR="$HOME/Desktop/wall"
CURRENT_WALL_FILE="$HOME/.config/i3/.current_wallpaper"

# 1. Build the list of images formatted with icons for Rofi
ROFI_INPUT=""
for img in "$WALL_DIR"/*; do
    if [ -f "$img" ]; then
        filename=$(basename "$img")
        # Format: filename \0 icon \x1f /path/to/image
        ROFI_INPUT+="${filename}\0icon\x1f${img}\n"
    fi
done

# 2. Launch rofi using our custom grid theme
SELECTION=$(echo -en "$ROFI_INPUT" | rofi -dmenu \
    -i \
    -p " " \
    -theme ~/.config/rofi/wallpaper-grid.rasi)

# 3. Apply the choice if something was clicked/selected
if [ -n "$SELECTION" ]; then
    FULL_PATH="$WALL_DIR/$SELECTION"
    
    nitrogen --set-zoom-fill "$FULL_PATH"
    echo "$FULL_PATH" > "$CURRENT_WALL_FILE"
fi
