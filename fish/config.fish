# some more ls aliases
alias ll "ls -alF"
alias la "ls -A"
alias l "ls -CF"

alias dco "docker-compose"

# git aliases
# source ~/.git/git-completion.bash
alias gtd "git difftool -t vimdiff"
alias gcm "git commit -m"
alias ggs "git status"
alias gb "git branch -vv" # More verbose and useful display of branches
alias gl "git log --graph --decorate --oneline"
alias gco "git checkout"
alias gf "git log --pretty=format: --name-only --diff-filter=A | sort -u"

# clear alias
alias cl "clear"

set -x GOPATH $HOME/go
set -x GOBIN $GOPATH/bin
set -x PATH $PATH $GOBIN

# activate py3 virtualenv
alias py3 "source /home/bob/ws/py3.venv/bin/activate"
# activate conda environment
alias bmi "source activate bmi"

# added by Miniconda3 installer
set -x PATH /home/bob/miniconda3/bin $PATH

# add fzf key bindings
fzf_key_bindings

