#!/bin/bash

# File: main_injector.sh
# Created: $(date +%Y-%m-%d)
# Description: Main injector that sources all dotfiles configurations

# Set the dotfiles path if not already set
export DOTFILES_PATH="${DOTFILES_PATH:-$HOME/.config/dotfiles}"
echo "Initializing dotfiles from: $DOTFILES_PATH"

# Source colors first (used by other scripts)
if [ -f "$DOTFILES_PATH/initialize/colors.sh" ]; then
    echo "Loading colors..."
    source "$DOTFILES_PATH/initialize/colors.sh"
fi

# Source all injectors
if [ -d "$DOTFILES_PATH/injectors" ]; then
    echo "Loading injectors..."
    for injector in "$DOTFILES_PATH/injectors"/*-injector; do
        if [ -f "$injector" ]; then
            echo "Sourcing injector: $injector"
            source "$injector"
        fi
    done
    unset injector
else
    echo "Warning: injectors directory not found at $DOTFILES_PATH/injectors"
fi

# Print welcome message if exists
if [ -f "$DOTFILES_PATH/initialize/welcome.sh" ]; then
    source "$DOTFILES_PATH/initialize/welcome.sh"
fi 