#!/bin/sh
# Check if Zsh is the current shell
if [ -z "$ZSH_VERSION" ]; then
  echo "This script is designed for Zsh. Please run it in a Zsh terminal."
  return 1
fi

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Help Function
navigate_help() {
  echo "${YELLOW}Navigate Script Help${NC}"
  echo "-----------------------"
  echo "${GREEN}Usage:${NC} navigate [options]"
  echo ""
  echo "${BLUE}Options:${NC}"
  echo "  --help, -h, help : Display this help menu"
  echo "  [directory name] : Navigate directly to a directory (auto_cd)"
  echo "  cd.., cd..., etc : Navigate up multiple directories"
  echo "  cdu <number>     : Navigate up <number> of directories"
  echo "  bk, back         : Navigate to previous directory"
  echo "  mcd <dir>        : Create and navigate to directory"
  echo "  cdl <dir>        : Navigate to directory and list contents"
  echo "  ..               : Shortcut for cd .."
  echo ""
  echo "${MAGENTA}Examples:${NC}"
  echo "  navigate --help"
  echo "  navigate Documents"
  echo "  navigate cdu 3"
  echo "  navigate mcd new_project"
  echo "  .. (navigates up one directory)"
  echo ""
  echo "${CYAN}Directory Stack Commands:${NC}"
  echo "  dirs        : Show directory stack"
  echo "  pushd <dir> : Push directory to stack and cd to it"
  echo "  popd        : Pop directory from stack and cd to it"
  echo "  d           : Show numbered directory stack"
  echo "  1-9         : Quick jump to dirs stack position"
  echo ""
  echo "${CYAN}Recent Directories:${NC}"
  echo "  cdr         : Navigate to a recently visited directory"
  echo ""
  echo "${CYAN}Settings:${NC}"
  echo "  auto_cd     : Automatically cd into directories"
  echo "  cd aliases  : Various shortcuts for navigating directories"
  echo "  dircolors   : Directory listing with colors"
}

# Set the AUTO_CD option for Zsh
setopt auto_cd

# Create aliases for cd .. , cd ... , cd .... etc.
alias cd..="cd .."
alias cd...="cd ../.."
alias cd....="cd ../../.."
alias cd.....="cd ../../../.."
alias cd......="cd ../../../../.."
alias cd.......="cd ../../../../../.."

# Simple shortcut for cd .. (just type ..)
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

# Navigate back to previous directory
alias bk="cd -"
alias back="cd -"

# Make directory and cd into it
mcd() {
  mkdir -p "$1" && cd "$1"
}

# cd and ls in one command
cdl() {
  cd "$1" && ls -la
}

# Define a function for navigating up multiple directories
cd_up() {
  local num_dots="$1"
  local path=""
  if [[ -z "$num_dots" || ! "$num_dots" =~ ^[0-9]+$ ]]; then
    echo "${RED}Usage: cdu <number_of_levels>${NC}"
    return 1
  fi
  for ((i = 1; i <= $num_dots; i++)); do
    path+="../"
  done
  cd "$path"
}

# Alias for the cd_up function
alias cdu='cd_up'

# Directory stack enhancements
setopt autopushd pushdminus pushdsilent pushdtohome pushdignoredups
DIRSTACKSIZE=10

# Quick access to directory stack
alias d='dirs -v'
for index ({1..9}) alias "$index"="cd +${index}"; unset index

# Enable directory history
if [[ -z $ZSH_VERSION ]]; then
  echo "${RED}cdr requires Zsh${NC}"
else
  autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
  add-zsh-hook chpwd chpwd_recent_dirs
  zstyle ':chpwd:*' recent-dirs-max 10
  zstyle ':chpwd:*' recent-dirs-default true
fi

# Enhanced directory listing
if whence dircolors >/dev/null; then
  eval "$(dircolors -b)"
  alias ls='ls --color=auto'
else
  export CLICOLOR=1
  alias ls='ls -G'
fi
alias ll='ls -la'
alias la='ls -A'
alias l='ls -CF'

# Navigation command with multiple help options
navigation() {
  if [[ "$1" == "--help" || "$1" == "-h" || "$1" == "help" || "$1" == "--h" || "$1" == "-help" ]]; then
    navigate_help
    return 0
  elif [[ "$1" == "cdu" && -n "$2" ]]; then
    cd_up "$2"
  elif [[ "$1" == "mcd" && -n "$2" ]]; then
    mcd "$2"
  elif [[ "$1" == "cdl" && -n "$2" ]]; then
    cdl "$2"
  elif [[ -n "$1" ]]; then
    cd "$1"
  else
    echo "${YELLOW}Navigation Tools Loaded. Use 'navigation --help' for options.${NC}"
  fi
}

# Create aliases for all help command formats
alias navigate='navigation'
alias navigate-h='navigation --help'
alias navigate--h='navigation --help'
alias navigate-help='navigation --help'
alias navigate--help='navigation --help'
alias navigatehelp='navigation --help'

# Set up shell prompt to show current directory
PROMPT='%F{cyan}%n%f@%F{green}%m%f:%F{yellow}%~%f$ '

# Add shortcut for quickly editing this file
alias edit_nav='${EDITOR:-nano} ${ZDOTDIR:-$HOME}/.zshrc'

# Show that navigation tools are loaded
echo "${GREEN}Zsh navigation enhancements loaded.${NC}"
echo "${BLUE}Type 'navigate --help' or any help variant for available commands.${NC}"
