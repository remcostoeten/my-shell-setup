#!/bin/bash

# =============================================================================
#   File: versioning.sh
#   Description: Handles version management for dotfiles
#   Created: $(date +%Y-%m-%d)
#   Author: remcostoeten
# =============================================================================

VERSION_FILE="$HOME/.config/dotfiles/version.txt"

increment_version() {
    local version=$1
    local increment_type=${2:-minor}
    
    # Remove 'VERSION=' prefix if present
    version=${version#VERSION=}
    
    IFS='.' read -r major minor patch <<< "$version"
    
    case $increment_type in
        major)
            ((major++))
            minor=0
            patch=0
            ;;
        medium)
            ((minor++))
            patch=0
            ;;
        *)  # minor/patch
            ((patch++))
            ;;
    esac
    
    echo "$major.$minor.$patch"
}

update_version() {
    local increment_type=$1
    
    # Create version file if it doesn't exist
    if [ ! -f "$VERSION_FILE" ]; then
        echo "VERSION=0.0.1" > "$VERSION_FILE"
        echo "LAST_UPDATED=$(date '+%Y-%m-%d %H:%M:%S')" >> "$VERSION_FILE"
    fi
    
    # Read current version, removing any 'VERSION=' prefix
    local current_version=$(grep "VERSION=" "$VERSION_FILE" | cut -d'=' -f2)
    local new_version=$(increment_version "$current_version" "$increment_type")
    local current_datetime=$(date '+%Y-%m-%d %H:%M:%S')
    
    # Update version file
    echo "VERSION=$new_version" > "$VERSION_FILE"
    echo "LAST_UPDATED=$current_datetime" >> "$VERSION_FILE"
    
    echo "Updated version to $new_version ($current_datetime)"
}

# Add git hook installation function
install_git_hooks() {
    local hook_path="$HOME/.config/dotfiles/.git/hooks/pre-commit"
    local hook_content='#!/bin/bash
source "$HOME/.config/dotfiles/initialize/versioning.sh"
update_version "minor"
git add version.txt'

    # Create hooks directory if it doesn't exist
    mkdir -p "$(dirname "$hook_path")"
    
    # Create the pre-commit hook
    echo "$hook_content" > "$hook_path"
    chmod +x "$hook_path"
    
    echo "Git pre-commit hook installed successfully"
}

# Install git hooks if this script is run directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    install_git_hooks
fi 