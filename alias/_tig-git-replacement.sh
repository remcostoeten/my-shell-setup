#!/bin/bash

# tig_aliases.sh
#
# This script provides aliases for tig to replace standard git commands.
# It also includes a colorful helper function to display usage information.
#
# Usage: Source this file in your .zshrc
# Example: source /path/to/tig_aliases.sh

# Color definitions
BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Helper function to display usage information
tig_help() {
  echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
  echo -e "${BLUE}║                     ${YELLOW}Tig Aliases Usage${BLUE}                     ║${NC}"
  echo -e "${BLUE}╠════════════════════════════════════════════════════════════╣${NC}"
  echo -e "${BLUE}║ ${GREEN}git status   ${YELLOW}-${NC} Show repository status (tig status)          ${BLUE}║${NC}"
  echo -e "${BLUE}║ ${GREEN}git log      ${YELLOW}-${NC} Show commit logs (tig)                       ${BLUE}║${NC}"
  echo -e "${BLUE}║ ${GREEN}git diff     ${YELLOW}-${NC} Show changes between commits, etc (tig diff) ${BLUE}║${NC}"
  echo -e "${BLUE}║ ${GREEN}git blame    ${YELLOW}-${NC} Show last modification details (tig blame)   ${BLUE}║${NC}"
  echo -e "${BLUE}║ ${GREEN}git branch   ${YELLOW}-${NC} Show branches (tig refs)                     ${BLUE}║${NC}"
  echo -e "${BLUE}║ ${GREEN}tig help     ${YELLOW}-${NC} Display this help message                    ${BLUE}║${NC}"
  echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
}

# Alias definitions
alias git status='tig status'
alias git log='tig'
alias git diff='tig diff'
alias git blame='tig blame'
alias git branch='tig refs'
alias githelp='tig_help'

# Inform the user that aliases have been set
echo -e "${GREEN}Tig aliases have been set. Use '${YELLOW}tig help${GREEN}' for usage information.${NC}"
