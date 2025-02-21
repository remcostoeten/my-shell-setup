#!/bin/bash

SCRIPTS_DIR="/home/remcostoeten/projects/zsh-setup/scripts"

# Define scripts to source
declare -a SCRIPTS=(
  "cz.sh"
  "generate-secret-jwt-to-clipboard.sh"
  "nvidia-fan-control.sh"
  "search-wrapper.sh"
  "docker-manager/docker-manager.sh"
  "alarm.sh"
)

# Alias for ripgrep
alias rip='python3 /home/remcostoeten/projects/zsh-setup/scripts/ripgrep.py'

# Source scripts with error handling
for script in "${SCRIPTS[@]}"; do
  script_path="${SCRIPTS_DIR}/${script}"
  if [ -f "$script_path" ]; then
    if ! source "$script_path" 2>/dev/null; then
      echo -e "\e[31mError: Failed to source $(basename "$script_path")\e[0m"
    fi
  else
    echo -e "\e[33mWarning: Script not found: $(basename "$script_path")\e[0m"
  fi
done
