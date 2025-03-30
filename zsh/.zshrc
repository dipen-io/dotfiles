#freshly new zshrc for void
#export
export ZSH="$HOME/.oh-my-zsh"
export PATH=$PATH:/usr/local/node/bin

export PATH="/opt/zig:$PATH"
export EDITOR='nvim'
# export MANPATH="/usr/local/man:$MANPATH"

ZSH_THEME="robbyrussell"
plugins=(git)
source $ZSH/oh-my-zsh.sh

# Aliases
alias vim='nvim'
alias vi='nvim'
alias ..='cd ..'
alias so='source'
# alias tls='tmux ls'
alias la='ls -a'
alias ll='ls -la'
alias e='exit'
alias home='cd ~'
alias c='cd'
alias clr='clear'
alias h='home'
alias gs='git status'
alias ga='git add .'
alias gj='git commit'
alias dps='sudo docker ps -a'
alias dim='sudo docker images'
# alias s='$HOME/script/pick_session.sh'
 alias s='$HOME/script/python.py'

# for emacs 
export XDG_CONFIG_HOME="$HOME/.config"
export EMACSDIR="$HOME/.config/emacs"

# vim keybinding
bindkey -v

#auto reload .zshrc
function auto_source_zshrc() {
    local last_modified=$(stat -c %Y ~/.zshrc)
    while true; do
        sleep 2
        local current_modified=$(stat -c %Y ~/.zshrc)
        if [[ $current_modified != $last_modified ]]; then
            source ~/.zshrc
            echo ".zshrc reloaded at $(date)"
            last_modified=$current_modified
        fi
    done
}
