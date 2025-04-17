#!/bin/bash

# =============================================================================
#   File: welcome.sh
#   Description: Displays a simple welcome message with version info
#   Created: $(date +%Y-%m-%d)
#   Author: remcostoeten
# =============================================================================

# Source colors if available
if [ -f "$HOME/.config/dotfiles/initialize/colors.sh" ]; then
  source "$HOME/.config/dotfiles/initialize/colors.sh"
else
  # Fallback colors
  GREEN='\033[0;32m'
  BLUE='\033[0;34m'
  NC='\033[0m'
fi

# Get current version and last updated date
get_current_version() {
  if [ -f "$HOME/.config/dotfiles/version.txt" ]; then
    grep "VERSION=" "$HOME/.config/dotfiles/version.txt" | cut -d'=' -f2
  else
    echo "0.0.1"
  fi
}

get_last_updated() {
  if [ -f "$HOME/.config/dotfiles/version.txt" ]; then
    grep "LAST_UPDATED=" "$HOME/.config/dotfiles/version.txt" | cut -d'=' -f2
  else
    date '+%Y-%m-%d %H:%M:%S'
  fi
}

# Simplified welcome message
display_welcome() {
  local version=$(get_current_version)
  local last_updated=$(get_last_updated)

  echo -e "${BLUE}remco's shell ${GREEN}(${version}) ${BLUE}• last updated: \
${GREEN}${last_updated}${NC}"
  echo
}

# Function to get shell configuration info
get_shell_info() {
  local shell_name shell_version
  shell_name=$(basename "$SHELL")
  shell_version=$($SHELL --version | head -n 1)
  echo "$shell_name ($shell_version)"
}

# Function to get system info
get_system_info() {
  local os_name os_version
  if [[ "$OSTYPE" == "darwin"* ]]; then
    os_name="macOS"
    os_version=$(sw_vers -productVersion)
  else
    os_name=$(uname -s)
    os_version=$(uname -r)
  fi
  echo "$os_name $os_version"
}

# Function to center text
center_text() {
  local text="$1"
  local width=$(tput cols)
  local padding=$(( (width - ${#text}) / 2 ))
  printf "%${padding}s%s\n" "" "$text"
}

# Function to display welcome help
print_welcome_help() {
  echo
  echo "Welcome Message Help"
  echo "==================="
  echo
  echo "The welcome message displays:"
  echo "• Current shell configuration version"
  echo "• Last update date"
  echo
  echo "To display welcome message manually:"
  echo "$ display_welcome"
  echo
}

# Export the function
export -f display_welcome

# Export help function
export -f print_welcome_help

# Create welcome help alias
alias welcome-help='print_welcome_help'

# *DO NOT EXECUTE ANYTHING WHEN SOURCED*
# The key is to only run the welcome message when the script is
# *executed directly* and *not* when it's sourced.

if [[ "${BASH_SOURCE[0]}" == "${0}" && -n "$PS1" ]]; then
  # Main execution (only if the script is the main program AND is interactive)
  case $1 in
    --help | -h)
      print_welcome_help
      ;;
    *)
      display_welcome
      ;;
  esac
fi
