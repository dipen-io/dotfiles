#!/bin/dash

# ^c$var^ = fg color
# ^b$var^ = bg color

mem() {
    printf "^c$blue^^b$black^  "
    printf "^c$blue^ $(free -h | awk '/^Mem/ { print $3 }' | sed s/i//g)"
}

interval=0

# load colors
# . ~/.config/chadwm/scripts/bar_themes/onedark
. ~/.config/bar/bar_themes/onedark


# It will check is ther any updates
pkg_updates() {
  # Refresh package index first
  /usr/sbin/xbps-install -Sy > /dev/null 2>&1

  # Check how many updates are available
  updates=$(/usr/sbin/xbps-install -un | wc -l)

  if [ "$updates" -eq 0 ]; then
    echo "^c$green^  Fully Updated"
  else
    echo "^c$green^  $updates updates"
  fi
}


get_date() {
    echo "$(date +'%Y-%m-%d')"
}

get_time() {
    echo "$(date +'%I:%M:%S %p')"
}

battery() {
    get_capacity=$(cat /sys/class/power_supply/BAT0/capacity 2>/dev/null || echo "N/A")
    echo "^c$blue^   $get_capacity%"
}

brightness() {
    current=$(brightnessctl g)
    max=$(brightnessctl m)
    percent=$((current * 100 / max))
    echo "^c$red^  $percent%"
}

wlan() {
    state=$(cat /sys/class/net/wl*/operstate 2>/dev/null)
    case "$state" in
        up) echo "^c$black^ ^b$blue^ 󰤨 ^d^ ^c$blue^Connected" ;;
        down) echo "^c$black^ ^b$blue^ 󰤭 ^d^ ^c$blue^Disconnected" ;;
        *) echo "^c$blue^ No WiFi" ;;
    esac
}

wifi() {
    ssid=$(nmcli -t -f active,ssid dev wifi | awk -F: '$1=="yes" {print $2}' 2>/dev/null)
    [ -n "$ssid" ] && echo "^c$blue^   $ssid" || echo "^c$blue^ No WiFi"
}
disk() {
   disk=$(df -h / | awk 'NR==2 {print $4}')
    echo "^c$blue^   $disk/"
}

volument() {
    volume=$(pactl get-sink-volume @DEFAULT_SINK@ | awk '{print $5}' | head -n 1 | tr -d '%')
    muted=$(pactl get-sink-mute @DEFAULT_SINK@ | awk '{print $2}')

    if [ "$muted" = "yes" ]; then
        echo "^c$green^  Mute"
    else
        if [ "$volume" -lt 30 ]; then
            icon=""
        elif [ "$volume" -lt 70 ]; then
            icon=""
        else
            icon=""
        fi
        echo "^c$green^ $icon $volume%"
    fi
}

# Main loop
while true; do
    [ "$interval" = 0 ] || [ $((interval % 3600)) = 0 ] && updates=$(pkg_updates)
    interval=$((interval + 1))

    xsetroot -name "$updates $(disk) $(battery) $(brightness) $(wifi) $(volument) $(get_date) $(get_time)"
    sleep 1
done
