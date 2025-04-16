#!/bin/bash

# File: versioning.sh
# Created: $(date +%Y-%m-%d)
# Description: Handles version management for dotfiles

VERSION_FILE="$DOTFILES_PATH/initialize/version.txt"

increment_version() {
    local version=$1
    local increment_type=${2:-minor}
    
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
    local current_version=$(head -n 1 "$VERSION_FILE")
    local new_version=$(increment_version "$current_version" "$increment_type")
    local current_date=$(date +%Y-%m-%d)
    
    echo "$new_version" > "$VERSION_FILE"
    echo "$current_date" >> "$VERSION_FILE"
    
    echo "Updated version to $new_version ($current_date)"
} 