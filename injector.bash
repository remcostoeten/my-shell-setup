#!/bin/bash

function_dir="$(dirname "${BASH_SOURCE[0]}")/functions"

sourced_count=0
failed_count=0

while IFS= read -r -d '' file; do
    if source "$file" 2>/dev/null; then
        ((sourced_count++))
    else
        echo "Failed to source: $file"
        ((failed_count++))
    fi
done < <(find "$function_dir" -type f -name "*.bash" -print0)

echo "Sourced $sourced_count functions. Failed to source $failed_count."
