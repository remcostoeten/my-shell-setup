# Basic git commands
alias g='git'
alias ga='git add'
alias gs='git status'
alias gf='git fetch'
alias gb='git branch'
alias gl='git log'

# Push/Pull
alias gp='git push'
alias gpf='git push --force-with-lease'
alias gpl='git pull'

# Branch management
alias gco='git checkout'
alias gcb='git checkout -b'
alias gbr='git branch'

# Commit related
function gcm() {
    git commit -m "$*"
    source "${UTILS_PATH}/_timestamp.sh"
    update_timestamp
}

# Combined commands
function gc() {
    git add .
    git commit -m "$1"
    source "${UTILS_PATH}/_timestamp.sh"
    update_timestamp
    git push
}

# Remote operations
alias gr='git remote -v'
alias grc='git remote -v | awk "NR==1 {print \$2}" | xclip -selection clipboard'
alias gcl='git clone'

