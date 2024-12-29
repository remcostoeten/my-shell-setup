#!/bin/bash

BASE_PATH="${HOME}/projects/zsh-setup"

# Files to remove
files_to_remove=(
    "alias/_cli-shortcuts.sh"
    "alias/_dev-shortcuts.sh"
    "alias/_docker-shortcuts.sh"
    "alias/_drizzle.sh"
    "alias/_prisma.sh"
    "utils/_task-adder.sh"
    "utils/_restart-dev.sh"
    "utils/_print-current-path.sh"
    "utils/_open-postgres.sh"
    "utils/_create_dockerdb_interactive.sh"
    "utils/_autojump"
    "utils/_screen-manager.sh"
    "alias/_print-errors.sh"
    "alias/print-overdue-tasks.sh"
    "scripts/drop_all_tables.sql"
)

# Print files that will be removed if they exist
echo "The following files will be removed if they exist:"
for file in "${files_to_remove[@]}"; do
    full_path="${BASE_PATH}/${file}"
    if [ -f "$full_path" ]; then
        echo "Found: $file"
    fi
done

# Ask for confirmation
read -p "Do you want to proceed with deletion? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    # Remove each file
    for file in "${files_to_remove[@]}"; do
        full_path="${BASE_PATH}/${file}"
        if [ -f "$full_path" ]; then
            rm -f "$full_path"
            echo "Removed: $file"
        fi
    done
    echo "Cleanup complete!"
else
    echo "Operation cancelled."
fi 
