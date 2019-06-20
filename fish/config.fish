# some more ls aliases
alias ll "ls -alF"
alias la "ls -A"
alias l "ls -CF"

alias dco "docker-compose"

alias cl "clear"

# git aliases
# source ~/.git/git-completion.bash
alias gtd "git difftool -t vimdiff"
alias gcm "git commit -m"
alias ggs "git status"
alias gb "git branch -vv" # More verbose and useful display of branches
alias gl "git log --graph --decorate --oneline"
alias gco "git checkout"
alias gf "git log --pretty=format: --name-only --diff-filter=A | sort -u"
alias gp "git pull"

# golang
set -x GOPATH $HOME/go
set -x GOBIN $GOPATH/bin
set -x PATH $PATH $GOBIN
set -x PATH $PATH /usr/local/go/bin

# added by Miniconda3 installer
set -x PATH /home/bob/miniconda3/bin $PATH
source (conda info --root)/etc/fish/conf.d/conda.fish

# rust
source ~/.cargo/env

# binaries
set -x PATH /home/bob/bin $PATH
