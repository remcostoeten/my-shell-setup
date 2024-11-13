#!/bin/bash

# =============================================================================
#                          Configuration
# =============================================================================

REPO_URL="https://github.com/remcostoeten/my-shell-setup.git"
REPO_PATH="${HOME}/projects/zsh-setup"
CONFIG_FILE="${REPO_PATH}/_last_update.txt"

# =============================================================================
#                          Color Definitions
# =============================================================================

# ANSI color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RESET='\033[0m'

# =============================================================================
#                          Helper Functions
# =============================================================================

get_current_time() {
  date +"%H:%M"
}

get_uptime() {
  uptime -p | sed 's/up //'
}

get_greeting() {
  local hour=$(date +"%H")
  if [ $hour -lt 12 ]; then
    echo "Good morning!"
  elif [ $hour -lt 18 ]; then
    echo "Good afternoon!"
  else
    echo "Good evening!"
  fi
}

get_last_update() {
  if [ -d "${REPO_PATH}/.git" ]; then
    cd "${REPO_PATH}"
    git log -1 --format="%cd" --date=format:"%d %b %H:%M" 2>/dev/null || echo "Unknown"
    cd - >/dev/null
  else
    echo "Unknown"
  fi
}

check_for_updates() {
  if [ -d "${REPO_PATH}/.git" ]; then
    cd "${REPO_PATH}"
    git fetch origin >/dev/null 2>&1
    local_rev=$(git rev-parse HEAD)
    remote_rev=$(git rev-parse origin/main 2>/dev/null || git rev-parse origin/master)
    if [ "$local_rev" != "$remote_rev" ]; then
      echo "Updates available!"
      return 0
    fi
    cd - >/dev/null
  fi
  return 1
}

# =============================================================================
#                          Update Function
# =============================================================================

update_shell_config() {
  echo "Updating shell configuration..."
  if [ -d "${REPO_PATH}/.git" ]; then
    cd "${REPO_PATH}"
    git pull origin main || git pull origin master
    echo "Last update: $(get_last_update)" >"${CONFIG_FILE}"
    source "${HOME}/.zshrc"
    cd - >/dev/null
    echo "Configuration updated successfully!"
  else
    echo "Git repository not found. Cloning..."
    git clone "${REPO_URL}" "${REPO_PATH}"
    echo "Last update: $(get_last_update)" >"${CONFIG_FILE}"
    source "${HOME}/.zshrc"
  fi
}

# =============================================================================
#                          Welcome Message
# =============================================================================

print_welcome_message() {
  local greeting=$(get_greeting)
  local current_time=$(get_current_time)
  local uptime=$(get_uptime)
  local last_update=$(get_last_update)

  # Create rainbow border
  local border="╔════════════════════════════════════════════════════════════════╗"
  local bottom_border="╚════════════════════════════════════════════════════════════════╝"

  echo ""
  echo -e "${CYAN}${border}${RESET}"
  echo -e "  ${YELLOW}${greeting} ${current_time}${RESET} ${BLUE}Uptime:${RESET} ${uptime}"
  echo -e ""
  echo -e "  ${RED}@remcostoeten${GREEN}'s shell config${RESET}, ${BLUE}last updated:${PURPLE} ${last_update}${RESET}"

  if check_for_updates; then
    echo -e "  ${YELLOW}Updates available! Run '${GREEN}update-shell${YELLOW}' to update.${RESET}"
  fi

  echo -e "${CYAN}${bottom_border}${RESET}"
  echo -e "type '${RED}zshhelp${RESET}' or '${RED}help${RESET}' for full zsh-helper menu"
  echo ""
}

# =============================================================================
#                          Alias Definition
# =============================================================================

# Add the update alias
alias update-shell='update_shell_config'

# =============================================================================
#                          Initial Run
# =============================================================================

# Print welcome message on startup
print_welcome_message
