#!/bin/bash

# Get the directory of the current script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Function to source files recursively
source_files() {
    local dir="$1"
    for item in "$dir"/*; do
        if [ -d "$item" ]; then
            source_files "$item"
        elif [ -f "$item" ] && [[ "$item" == *.bash ]] && [[ "$item" != "$SCRIPT_DIR/function_injector.bash" ]]; then
            source "$item"
            echo a "Sourced: $item"
        fi
    done
}

# Source all .bash files in the current directory and its subdirectories
source_files "$SCRIPT_DIR"

echo "All functions have been loaded."
