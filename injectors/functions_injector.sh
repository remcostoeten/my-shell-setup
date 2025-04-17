#!/bin/bash

# =============================================================================
#   File: functions_injector.sh
#   Description: Sources all function files
#   Created: $(date +%Y-%m-%d)
#   Author: remcostoeten
# =============================================================================

FUNCTIONS_DIR="$HOME/.config/dotfiles/functions"

# Create functions directory if it doesn't exist
if [ ! -d "$FUNCTIONS_DIR" ]; then
    mkdir -p "$FUNCTIONS_DIR"
fi

# Source all files in the functions directory
for file in "$FUNCTIONS_DIR"/*.sh; do
    if [ -f "$file" ]; then
        source "$file"
    fi
done 