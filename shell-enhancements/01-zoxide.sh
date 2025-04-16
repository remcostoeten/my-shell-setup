# Zoxide Configuration
# Smart directory jumping tool
# Created: $(date '+%Y-%m-%d')

# Initialize zoxide with 'z' command (keeping normal cd behavior)
eval "$(zoxide init zsh)"

# Basic directory navigation aliases
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ~='cd ~'
alias -- -='cd -'

# Usage examples (as comments for reference):
# z foo       # cd into highest ranked directory matching foo
# z foo bar   # cd into highest ranked directory matching foo and bar
# z foo/      # cd into a subdirectory starting with foo
# zi         # cd with interactive selection using fzf 