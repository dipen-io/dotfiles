#!/usr/bin/env bash

# Prompt for input
query=$(rofi -dmenu -p "Search the web:")

# Exit if input is empty
[ -z "$query" ] && exit 1

# Encode the query for a URL
encoded_query=$(xdg-open "https://www.google.com/search?q=$(printf '%s\n' "$query" | sed 's/ /+/g')")

# Check if Firefox is running
if ! pgrep -x "zen" > /dev/null; then
    # If not, open Firefox with the search
    firefox "https://www.google.com/search?q=$query" &
else
    # firefox is running – open a new tab with search
    zen "https://www.google.com/search?q=$query"
fi

