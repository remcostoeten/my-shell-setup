#!/bin/bash

UTILS_DIR="/home/remcostoeten/projects/zsh-setup/utils"

# Utility scripts
TASK_ADDER="$UTILS_DIR/_task-adder.sh"
RESTART_DEV="$UTILS_DIR/_restart-dev.sh"
PRINT_PATH="$UTILS_DIR/_print-current-path.sh"
OPEN_POSTGRES="$UTILS_DIR/_open-postgres.sh"
CREATE_DOCKERDB="$UTILS_DIR/_create_dockerdb_interactive.sh"
AUTOJUMP="$UTILS_DIR/_autojump"

# Source _task-adder.sh with error handling
if ! source "$TASK_ADDER" 2>/dev/null; then
  echo -e "\e[31mError: Failed to source _task-adder.sh\e[0m"
fi

# Source other utility scripts
for script in "$RESTART_DEV" "$PRINT_PATH" "$OPEN_POSTGRES"; do
  if ! source "$script" 2>/dev/null; then
    echo -e "\e[31mError: Failed to source $(basename "$script")\e[0m"
  fi
done
