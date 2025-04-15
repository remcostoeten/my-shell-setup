#!/bin/bash

export DOTFILES_PATH="${DOTFILES_PATH:-$HOME/.config/dotfiles}"

# core_injector_path="$DOTFILES_PATH/core/envs-injector.sh"
# if [ -f "$core_injector_path" ]; then
#     . "$core_injector_path"
# else
#     echo "Warning: Core injector not found: $core_injector_path" >&2
# fi

#!/bin/bash

for file in "$DOTFILES_PATH/injectors/"*; do
    if [ -f "$file" ]; then
        source "$file"
    fi
done 