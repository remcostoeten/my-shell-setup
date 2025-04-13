#!/bin/bash

# Set DOTFILES_PATH if not already set
export DOTFILES_PATH="${DOTFILES_PATH:-$HOME/.config/dotfiles}"

# Source all injecto≈
source "$DOTFILES_PATH/core/envs-injector.sh"


INJECTOR_PATHS=(
    "./core/envs-injector.sh"
)
