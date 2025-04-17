#!/bin/bash

# =============================================================================
#   File: main_injector.sh
#   Description: Main configuration injector
#   Created: $(date +%Y-%m-%d)
#   Author: remcostoeten
# =============================================================================

# Source colors first
source "$HOME/.config/dotfiles/initialize/colors.sh" 2>/dev/null

# Source all injectors silently
for injector in "$HOME/.config/dotfiles/injectors"/*_injector.sh; do
    if [ -f "$injector" ]; then
        source "$injector" 2>/dev/null
    fi
done

# Display only the welcome message
if [ -f "$HOME/.config/dotfiles/initialize/welcome.sh" ]; then
    source "$HOME/.config/dotfiles/initialize/welcome.sh"
    display_welcome
fi 