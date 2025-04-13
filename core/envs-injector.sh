#!/bin/bash

# Source all environment variable files
for file in "$DOTFILES_PATH/core/environment-variables/"*.sh; do
    if [ -f "$file" ]; then
        source "$file"
    fi
done
