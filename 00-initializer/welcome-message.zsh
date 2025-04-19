#!/bin/zsh

# Version information
DOTFILES_VERSION="v1.0.1"
LAST_UPDATED=$(date "+%Y-%m-%d %H:%M:%S")

# Only show welcome message if not in quiet mode
if [[ -z $DOTFILES_QUIET ]]; then
    echo "\n⚡ RemcoStoeten's Shell Config ⚡"
    echo "🕒 Last updated: $LAST_UPDATED"
    echo "🧪 Version: $DOTFILES_VERSION\n"
fi 