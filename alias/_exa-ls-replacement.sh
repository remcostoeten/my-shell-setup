#!/bin/bash

alias ls='exa --icons --group-directories-first'
alias ll='exa -l --icons --group-directories-first'
alias la='exa -la --icons --group-directories-first'

#
# # Check if exa is installed
# if ! command -v exa &>/dev/null; then
#   echo "exa is not installed. Please install it first."
#   exit 1
# fi
#
# # Define aliases
# alias ls='exa --color=auto --icons'
# alias ll='exa -lah --color=auto --icons'
# alias la='exa -a --color=auto --icons'
# alias l='exa -F --color=auto --icons'
# alias lt='exa --tree --level=2 --color=auto --icons'
#
# # Define color codes
# RED='\033[0;31m'
# GREEN='\033[0;32m'
# YELLOW='\033[0;33m'
# BLUE='\033[0;34m'
# NC='\033[0m' # No Color
#
# # exahelp function
# exahelp() {
#   echo -e "${GREEN}Exa Help Menu:${NC}"
#   echo -e "${YELLOW}ls${NC} - List directory contents"
#   echo -e "${YELLOW}ll${NC} - List directory contents in long format"
#   echo -e "${YELLOW}la${NC} - List all directory contents (including hidden)"
#   echo -e "${YELLOW}l${NC}  - List directory contents with file type indicators"
#   echo -e "${YELLOW}lt${NC} - List directory contents in tree format (2 levels deep)"
#   echo -e "\n${BLUE}For more options, type: ${RED}exa --help${NC}"
# }
#
# # Add aliases and exahelp function to .bashrc
# echo "
# # Exa aliases
# alias ls='exa --color=auto --icons'
# alias ll='exa -lah --color=auto --icons'
# alias la='exa -a --color=auto --icons'
# alias l='exa -F --color=auto --icons'
# alias lt='exa --tree --level=2 --color=auto --icons'
#
# # Exahelp function
# $(declare -f exahelp)
#
# # Add exahelp alias
# alias exahelp='exahelp'
# " >>~/.bashrc
#
# # Source .bashrc to apply changes immediately
# source ~/.bashrc
#
# echo -e "${GREEN}Exa aliases and exahelp menu have been added to your .bashrc file.${NC}"
# echo -e "${YELLOW}Type 'exahelp' to see the help menu.${NC}"
