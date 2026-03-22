#!/usr/bin/env bash

set -euo pipefail


for cmd in tmux fzf; do
    if ! command -v "$cmd" &> /dev/null; then
        echo "Error: $cmd is not installed." >&2
        exit 1
    fi
done

switch_to() {
    if [[ -z "${TMUX:-}" ]]; then
        tmux attach-session -t "$1"
    else
        tmux switch-client -t "$1"
    fi
}

has_session() {
    tmux has-session -t "$1" 2>/dev/null
}

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
            # Add a small delay to ensure shell is ready
            tmux send-keys -t "$session_name" "sleep 0.1 && source $config" C-m
            break
        fi
    done
}

if [[ $# -eq 1 ]]; then
    selected=$1
else
    selected=$(find -L /home/dinesh -mindepth 1 -maxdepth 2 -type d \( \
        -path "/home/dinesh/dotfiles/*" -o \
        -path "/home/dinesh/startup/*" -o \
        -path "/home/dinesh/Desktop/*" -o \
        -path "/home/dinesh/dotfiles/script/*" -o \
        -path "/home/dinesh/mob_dev/*" \) -print | \
        fzf --preview 'ls -lh --color=always {}' --preview-window=right:50%)
fi

[[ -z "$selected" ]] && exit 0

selected_name="$(basename "$selected" | tr . _)"
if [[ -d "$selected/.git" ]]; then
    branch_name=$(git -C "$selected" branch --show-current 2>/dev/null || echo "main")
    selected_name="${selected_name}_${branch_name}"
fi

if has_session "$selected_name"; then
    switch_to "$selected_name"
else
    if [[ -z "${TMUX:-}" ]]; then
        # Outside tmux: create attached, then hydrate
        tmux new-session -s "$selected_name" -c "$selected"
        # Note: hydrate won't run here because new-session blocks until detach
    else
        # Inside tmux: create detached, hydrate, then switch
        tmux new-session -ds "$selected_name" -c "$selected"
        
        # CRITICAL FIX: Wait for session to be ready
        sleep 0.2
        
        hydrate "$selected_name" "$selected"
        switch_to "$selected_name"
    fi
fi
