alias cl="clear"
alias ll="ls -alF"
alias la="ls -A"
alias l="ls -CF"
# git aliases
alias gtd="git difftool -t vimdiff"
alias ggc="git commit"
alias ggs="git status"
alias ggb="git branch -vv" # More verbose and useful display of branches
alias ggl="git log --graph --decorate --oneline"
alias ggco="git checkout"
alias ggp="git pull"
alias ggf="git fetch"
# conda aliases
#alias ca="conda activate"
#alias cda="conda deactivate"

# prevent PATH changes on tmux start
if [ -n "$TMUX" ]; then
    if [ -f /etc/profile ]; then
        PATH=""
        source /etc/profile
    fi
fi

# case-insensitive matching only if there are no case-sensitive matches add ''
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'
autoload -Uz compinit && compinit -u

# golang
#export GOPATH=$HOME/go
#export GOBIN=$GOPATH/bin
#export PATH=$PATH:$GOBIN
#export PATH=$PATH:/usr/local/go/bin

# rust
#source ~/.cargo/env

# starship
#eval "$(starship init zsh)"

# binaries
#export PATH=$PATH:$HOME/.local/bin
#export PATH=$PATH:$HOME/bin

