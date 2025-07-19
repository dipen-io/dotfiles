#freshly new zshrc for void
#export
# export ZSH="$HOME/.oh-my-zsh"
export PATH=$PATH:/usr/local/node/bin
# export PATH="/usr/local/bin/zen:$PATH"

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt autocd extendedglob nomatch
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/void/.zshrc'

autoload -Uz compinit
compinit
PS1='\[\033[0;32m\][\u@\h \W]\$\[\033[0m\] '
# End of lines added by compinstall

export PATH="/opt/zig:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export EDITOR='nvim'

# alternative nvim config
alias a="NVIM_APPNAME=my-nvim nvim"
alias l=ll

# alias void="/home/void/.config/bar/fetch"
# "/home/void/.config/bar/fetch"


# for python tmp
# export TMPDIR=~/project/flask-ai/tmp
# export MANPATH="/usr/local/man:$MANPATH"

# ZSH_THEME="robbyrussell"
# ZSH_THEME="bira" # this is good

PROMPT='[%n] %~ '

plugins=(git)
# source $ZSH/oh-my-zsh.sh

# Aliases
# alias vim='nvim'
alias vi='nvim'
alias ..='cd ..'
alias so='source /home/void/.zshrc'
# alias tls='tmux ls'
alias la='ls -a'
alias ll='ls -la'
alias e='exit'
alias home='cd ~'
alias c='cd'
alias cl='clear'
alias h='home'
alias gs='git status'
alias ga='git add .'
alias gj='git commit'
alias dps='sudo docker ps -a'
alias dim='sudo docker images'
# alias s='$HOME/script/pick_session.sh'
alias s='$HOME/script/python.py'
alias todo='$HOME/script/todo'
alias tmux-sessionizer='/home/void/script/tmux_sessionaizer.sh'

run() {
    g++ "$1" -o a.out && ./a.out
}
# for emacs 
export XDG_CONFIG_HOME="$HOME/.config"
export EMACSDIR="$HOME/.config/emacs"

# vim keybinding
bindkey -v

# bindkey -s ^f "/home/void/script/tmux_sessionaizer.sh\n"
# bindkey -s ^n "/home/void/script/python.py\n"
# bindkey -s ^b "/home/void/script/rofi-web-serach.sh\n"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# . "/home/void/.deno/env"

# bun completions
[ -s "/home/void/.bun/_bun" ] && source "/home/void/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

#dotnet

export DOTNET_ROOT=$HOME/.dotnet
export PATH=$DOTNET_ROOT:$PATH

setopt NO_HIST_EXPAND
