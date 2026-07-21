# git aliases
# source ~/.git/git-completion.bash
alias ggtd='git difftool -t vimdiff'
alias ggc='git commit'
alias ggs='git status'
alias ggb='git branch -vv' # More verbose and useful display of branches
alias ggl='git log --graph --decorate --oneline'
alias ggco='git checkout'
alias ggf='git log --pretty=format: --name-only --diff-filter=A | sort -u'
alias ggp='git pull'

# clear alias
alias cl='clear'