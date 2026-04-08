#!/bin/bash

WALLPAPER_DIR="$HOME/Desktop/wall"

chosen=$(ls "$WALLPAPER_DIR" | rofi -dmenu -p "🖼 Wallpaper")
[ -z "$chosen" ] && exit

nitrogen --set-zoom-fill "$WALLPAPER_DIR/$chosen"
echo "$WALLPAPER_DIR/$chosen" > ~/.config/i3/.current_wallpaper
