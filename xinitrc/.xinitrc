# xrdb merge ~/.Xresources


# while true; do
#     date=$(date +'%Y-%m-%d')  # Current date
#     time=$(date +'%I:%M:%S %p')  # 12-hour format
#     disk=$(df -h / | awk 'NR==2 {print $4}')  # Available storage on /
#     battery=$(cat /sys/class/power_supply/BAT0/capacity 2>/dev/null || echo "N/A")  # Battery percentage
#     wifi=$(nmcli -t -f active,ssid dev wifi | awk -F: '$1=="yes" {print $2}' 2>/dev/null || echo "No WiFi")  # WiFi Name
#     volume=$(pactl get-sink-volume @DEFAULT_SINK@ | awk '{print $5}' | head -n 1)  # Sound Volume Percentage
#     brightness=$(brightnessctl g)  # Get current brightness level
#     max_brightness=$(brightnessctl m)  # Get maximum brightness level
#     brightness_percent=$((brightness * 100 / max_brightness))  # Convert to percentage
#
#     xsetroot -name " 󰃭 $wifi |  $disk |  $battery% |  $volume |  $brightness_percent% |  $date |  $time"
#     sleep 1
# done &


#xss-lock -- xsecurelock &  # Auto-lock the screen using xsecurelock
dunst &
setxkbmap -option
xmodmap ~/.Xmodmap &
# xset s 300 300  # Set screen timeout to 5 minutes


# xset r rate 150 80 & // it is good
xset r rate 190 35
#dash ~/.config/chadwm/scripts/bar.sh &
# while type chadwm >/dev/null; do chadwm && continue || break; done
#  exec i3

# Just run your main startup script
~/.config/scripts/run.sh


