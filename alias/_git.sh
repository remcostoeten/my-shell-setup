## git add; git commits with $1 being  the message and pushes. E.g. gcm some message here
alias gcm='f(){ git commit -m "${*}"; }; f'

alias g='git'
alias checkout='git checkout'
alias newranch='git checkout -b'
alias push='git push'
alias pull='git pull'
alias status='git status'
alias commit='git commit -m'
alias add='git add'
alias pushf='git push --force-with-lease'
alias pushf='git push --force-with-lease'
alias pushf='git push --force-with-lease'
alias remote='git remote -v'
alias copyremote='git remote -v | awk 'NR==1 {print $2}' | xclip -selection clipboard'
alias clone='git clone'
alias fetch='git fetch'
alias merge='git merge'
alias rebase='git rebase'
alias reset='git reset'
alias revert='git revert'
alias tag='git tag'
alias branch='git branch'
alias log='git log'

alias gc='git add . ; git commit -m "$1" ; git push'

