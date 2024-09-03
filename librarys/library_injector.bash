#!/bin/bash

# Library Injector Script

# Define the base directory for libraries
library_dir="$(dirname "${BASH_SOURCE[0]}")"

# Function to source library files
source_library() {
    local file="$1"
    if [ -f "$file" ]; then
        source "$file"
        echo "Sourced library: $(basename "$file")"
    else
        echo "Failed to source library: $(basename "$file")"
    fi
}

# Source all .bash files in the library directory
while IFS= read -r -d '' file; do
    source_library "$file"
done < <(find "$library_dir" -maxdepth 1 -type f -name "*.bash" -print0)

echo "All librari   es have been loaded."
