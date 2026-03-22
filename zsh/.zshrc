# ~/.zshrc - Clean & Fast Configuration
# ======================================

# ---- Oh-My-Zsh ----
export ZSH="$HOME/.oh-my-zsh"
DISABLE_AUTO_UPDATE="true"
ZSH_THEME="robbyrussell"
plugins=(git)
source $ZSH/oh-my-zsh.sh

# ---- Environment ----
export EDITOR=nvim
export VISUAL=nvim
export LANG=en_US.UTF-8
export XDG_CONFIG_HOME="$HOME/.config"

# ---- PATH (Consolidated & Clean) ----
typeset -U path  # Remove duplicates automatically
path=(

    $HOME/.local/bin
    $HOME/.local/bin/zen
    $HOME/dotfiles/bin
    /usr/local/node/bin
    $HOME/mob_dev/flutter/bin
    $HOME/mob_dev/flutter/bin/cache/dart-sdk/bin
    $ANDROID_SDK_ROOT/cmdline-tools/latest/bin
    $ANDROID_SDK_ROOT/platform-tools
    $path
)
export PATH

# ---- Android SDK ----
export ANDROID_SDK_ROOT="$HOME/Android/Sdk"

export PATH="$PATH:$HOME/go/bin"


# ---- History ----
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
setopt autocd extendedglob nomatch HIST_IGNORE_DUPS

# ---- Vi Mode ----
bindkey -v

# ---- Cursor Shape (Efficient) ----
# Only change cursor when entering/exiting insert mode
function zle-keymap-select {
    [[ $KEYMAP == vicmd ]] && echo -ne '\e[2 q' || echo -ne '\e[5 q'
}
zle -N zle-keymap-select

# ---- Aliases ----
alias vi='nvim'
alias ..='cd ..'
alias so='source $HOME/.zshrc'
alias la='ls -a'
alias ll='ls -la'
alias l='ls -la'  # Fixed: defined AFTER ll
alias e='exit'
alias home='cd ~'
alias c='cd'
alias cl='clear'
alias gs='git status'
alias ga='git add .'
alias gj='git commit'
alias dps='sudo docker ps -a'
alias dim='sudo docker images'
alias todo='$HOME/script/todo'
alias a="NVIM_APPNAME=my-nvim nvim"
alias ts='tmux-sessionizer'

# ---- Functions ----
run() {
    g++ "$1" -o a.out && ./a.out
}

# Tmux session picker (renamed to avoid overriding tmux command)
tmux-sessionizer() {
    local session
    session=$(tmux list-sessions -F '#S' 2>/dev/null | fzf --prompt="tmux session> " --height=40% --reverse)
    [[ -n "$session" ]] && tmux attach -t "$session" || echo "No session selected."
}

# ---- Key Bindings ----
bindkey -s '^g' '$HOME/script/rofi-web-serach.sh\n'
# bindkey -s '^p' '$HOME/script/tmux_sessionaizers.sh\n'

bindkey -s '^P' '
if [ -n "$TMUX" ]; then
  tmux new-window "$HOME/script/tmux_sessionaizers.sh"
else
  $HOME/script/tmux_sessionaizers.sh
fi
\n'
