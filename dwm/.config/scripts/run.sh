#!/bin/sh

xrdb merge ~/.Xresources 
#feh --bg-fill ~/Desktop/wall/62.png &
feh --bg-fill ~/dotfiles/wallpaper/wall1.jpg &
xset r rate 200 20 &
brightnessctl s 40% &   # <--- SET BRIGHTNESS TO 40%
picom &
# start the bar
dash ~/.config/bar/bar.sh &
# start dwm
while type chadwm >/dev/null; do chadwm && continue || break; done


