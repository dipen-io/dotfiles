#!/usr/bin/env bash

# Enhanced error handling
# e => exist emmediately if any command fails
# u => treat unset variable as error
# o: pipefail =>consider it as command fails
set -euo pipefail

# Check dependencies (tmux and fzf)
for cmd in tmux fzf; do
    if ! command -v "$cmd" &> /dev/null; then
        echo "Error: $cmd is not installed." >&2
        exit 1
    fi
done

# Function to switch to or attach to a session 
switch_to() {
    # check if we are inside an tmux session (TMUX env variable exist)
    if [[ -z "${TMUX:-}" ]]; then
        # if outside attach to the specified session 
        tmux attach-session -t "$1"
    else
        # if inside switch to client to the specified session 
        tmux switch-client -t "$1"
    fi
}

# Function to check if a session exists
has_session() {
    tmux has-session -t "$1" 2>/dev/null
}

# Function to hydrate a session with configuration
hydrate() {
    local session_name="$1"
    local dir="$2"
    local config_files=(
        "$dir/./tmux/yes1.sh"
        "$HOME/script/yes"
        "$dir/.tmux.conf"
        "$HOME/.tmux.conf"
    )

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
        -path "/home/void/Desktop/*" \) -print | \
        fzf --preview 'ls -lh --color=always {}' --preview-window=right:50%)
fi

[[ -z "$selected" ]] && exit 0

# Customize session name
selected_name="$(basename "$selected" | tr . _)"
if [[ -d "$selected/.git" ]]; then
    branch_name=$(git -C "$selected" branch --show-current 2>/dev/null || echo "main")
    selected_name="${selected_name}_${branch_name}"
fi

# Simplified session handling logic
if has_session "$selected_name"; then
    switch_to "$selected_name"
else
    if [[ -z "${TMUX:-}" ]]; then
        tmux new-session -s "$selected_name" -c "$selected"
        hydrate "$selected_name" "$selected"
    else
        tmux new-session -ds "$selected_name" -c "$selected"
        hydrate "$selected_name" "$selected"
        switch_to "$selected_name"
    fi
fi
