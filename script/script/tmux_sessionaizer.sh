#!/usr/bin/env bash

# Error handling
if ! command -v tmux &> /dev/null; then
    echo "Error: tmux is not installed."
    exit 1
fi

if ! command -v fzf &> /dev/null; then
    echo "Error: fzf is not installed."
    exit 1
fi

# Function to switch to a session
switch_to() {
    if [[ -z $TMUX ]]; then
        tmux attach-session -t "$1"
    else
        tmux switch-client -t "$1"
    fi
}

# Function to check if a session exists
has_session() {
    tmux list-sessions | grep -qE "^$1:"
}

# Function to hydrate a session with configuration
hydrate() {
    local session_name="$1"
    local dir="$2"
    local config_files=("$dir/.tmux-sessionizer" "$HOME/script/yes" "$dir/.tmux.conf" "$HOME/.tmux.conf")

    for config in "${config_files[@]}"; do
        if [[ -f "$config" ]]; then
            tmux send-keys -t "$session_name" "source $config" C-m
            break
        fi
    done
}

# Main script logic
if [[ $# -eq 1 ]]; then
    selected=$1
else
selected=$(find -L /home/void -mindepth 1 -maxdepth 2 -type d \( \
     -path "/home/void/dotfiles" -o \
     -path "/home/void/project/*" -o \
     -path "/home/void/dotfiles/script/*" -o \
     -path "/home/void/Desktop/*" \) -print | fzf --preview 'ls -lh --color=always {}' --preview-window=right:50%)

         # -path "/home/dinesh/go/src/*" \) -print | fzf --preview 'echo "Files: $(ls -1 {} | wc -l)\nSize: $(du -sh {} | cut -f1)"' --preview-window=right:50%)
fi

if [[ -z $selected ]]; then
    exit 0
fi

# Customize session name
selected_name="$(basename "$selected" | tr . _)"
if [[ -d "$selected/.git" ]]; then
    branch_name=$(git -C "$selected" branch --show-current)
    selected_name="${selected_name}_$branch_name"
fi

# Check if tmux is running
tmux_running=$(pgrep -x tmux)

# Create or switch to session
if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
    tmux new-session -s "$selected_name" -c "$selected"
    hydrate "$selected_name" "$selected"
    exit 0
fi

if ! has_session "$selected_name"; then
    tmux new-session -ds "$selected_name" -c "$selected"
    hydrate "$selected_name" "$selected"
fi

switch_to "$selected_name"
