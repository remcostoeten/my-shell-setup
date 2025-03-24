#!/bin/bash

# Define paths
BASE_PATH="${HOME}/projects/zsh-setup"
ALIAS_PATH="${BASE_PATH}/alias"
UTILS_PATH="${BASE_PATH}/utils"

# Load utilities first
source "${UTILS_PATH}/_timestamp.sh"
source "${UTILS_PATH}/_grep-folders-and-files.sh"

# Source alias files
source "${ALIAS_PATH}/_generics.sh"


# Core functionality
source "${ALIAS_PATH}/_git.sh"
source "${ALIAS_PATH}/_navigating.sh"
source "${ALIAS_PATH}/_shortcuts.sh"
source "${ALIAS_PATH}/_programs.sh"
source "${ALIAS_PATH}/_tig-git-replacement.sh"
source "${ALIAS_PATH}/_exa-ls-replacement.sh"  # Fixed spacing in filename
# Initialize help menu last
#source "${BASE_PATH}/initialize/_zsh-help-menu.sh"

alias xx='exit'
alias rmr=' rm -rf'
alias cc='clear'
alias dev='pnpm  run dev'
alias build='pnpm run build'
alias g='git'
alias p='pnpm'
alias push='git push'
alias pull='git pull'
alias gcm='git add . && git commit -m'