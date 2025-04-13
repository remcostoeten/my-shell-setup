#!/bin/bash

export DOTFILES_PATH="${DOTFILES_PATH:-$HOME/.config/dotfiles}"

core_injector_path="$DOTFILES_PATH/core/envs-injector.sh"
if [ -f "$core_injector_path" ]; then
    . "$core_injector_path"
else
    echo "Warning: Core injector not found: $core_injector_path" >&2
fi

# Paths relative to $DOTFILES_PATH
INJECTOR_PATHS_RELATIVE=(
    "injectors/alias-injector.sh"
    "injectors/function-injector.sh"
    # Add other injector paths here
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
