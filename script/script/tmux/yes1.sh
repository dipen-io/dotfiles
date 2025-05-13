
# This is an example .tmux-sessionizer file.
# Place this file in the root directory of a project.
# The hydrate function in your script will source this when you
# switch to or create a tmux session for this project.

# Example commands you might put here:

# Rename the current window to 'dev'
tmux rename-window 'dev'

# Split the current pane vertically
tmux split-window -v

# Change to a specific directory in the new pane (optional, if needed)
# tmux send-keys -t "$TMUX_SID.1" "cd src/" C-m

# Split the original pane horizontally
tmux split-window -h -t "$TMUX_SID.0"

# Select the top-left pane (index 0)
tmux select-pane -t 0

# Example content for yes1.sh - sets up project-specific tmux environment
tmux set-option -t "$TMUX_PANE" status-left "ProjectEnv "  # Custom status bar
tmux set-option -t "$TMUX_PANE" window-status-format "#I:#W#F"  # Window format

# Send commands to specific panes (replace 0, 1, 2 with actual pane indices)
# tmux send-keys -t "$TMUX_SID.0" "nvim ." C-m # Start neovim in pane 0
# tmux send-keys -t "$TMUX_SID.1" "npm run dev" C-m # Start dev server in pane 1
# tmux send-keys -t "$TMUX_SID.2" "git status" C-m # Check git status in pane 2

# You can add any bash commands or tmux commands here
# that you want to run when the session is hydrated.

echo "Sourced .tmux-sessionizer for this project!"
