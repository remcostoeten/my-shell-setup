#!/bin/bash

export DOTFILES_PATH="${DOTFILES_PATH:-$HOME/.config/dotfiles}"


# Paths relative to $DOTFILES_PATH
INJECTOR_PATHS_RELATIVE=(
    "injectors/alias-injector.sh"
    "injectors/function-injector.sh"
)

for injector_rel_path in "${INJECTOR_PATHS_RELATIVE[@]}"; do
    injector_full_path="$DOTFILES_PATH/$injector_rel_path"
    if [ -f "$injector_full_path" ]; then
        . "$injector_full_path"
    else
        echo "Warning: Injector file not found: $injector_full_path" >&2
    fi
done

unset core_injector_path INJECTOR_PATHS_RELATIVE injector_rel_path injector_full_path
