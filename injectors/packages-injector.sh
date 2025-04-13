#!/bin/bash

# Source all package management files
for file in "$DOTFILES_PATH/core/packages/"*.sh; do
    if [ -f "$file" ]; then
        source "$file"
    fi
done 