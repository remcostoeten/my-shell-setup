#!/bin/bash

# Default values for parameters
START_DIR="/"
SEARCH_STRING=""
EXTRA_EXCLUSIONS=()
RECURSIVE=true
MAX_DEPTH=""
MAX_NAME_LENGTH=""
MAX_FOLDER_SIZE=""

# Colors for better visuals
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
NO_COLOR='\033[0m'

# Print usage information
usage() {
    echo -e "${CYAN}Usage:${NO_COLOR} $0 ${GREEN}-s <search-string>${NO_COLOR} [${YELLOW}options${NO_COLOR}]"
    echo -e "${CYAN}Options:${NO_COLOR}"
    echo -e "  ${GREEN}-s <search-string>${NO_COLOR}     Search string (required)"
    echo -e "  ${YELLOW}-d <starting-dir>${NO_COLOR}     Starting directory (default: /)"
    echo -e "  ${YELLOW}-n${NO_COLOR}                    Non-recursive search"
    echo -e "  ${YELLOW}-l <max-depth>${NO_COLOR}        Maximum depth"
    return 1
}

# Parse arguments
while getopts "s:d:e:nl:L:S:" opt; do
    case $opt in
        s) SEARCH_STRING="$OPTARG" ;;
        d) START_DIR="$OPTARG" ;;
        e) EXTRA_EXCLUSIONS+=("$OPTARG") ;;
        n) RECURSIVE=false ;;
        l) MAX_DEPTH="$OPTARG" ;;
        L) MAX_NAME_LENGTH="$OPTARG" ;;
        S) MAX_FOLDER_SIZE="$OPTARG" ;;
        *) usage ;;
    esac
done

# Validate input
if [[ -z $SEARCH_STRING ]]; then
    echo -e "${RED}Error:${NO_COLOR} Search string (-s) is required."
    usage
fi

# Base exclusions
EXCLUSIONS=(
    "*/node_modules/*"
    "*/build/*"
    "*/dist/*"
    "*/.git/*"
    "*/target/*"
)

# Build find command
find_cmd() {
    local cmd="find \"$START_DIR\" -type d"
    
    # Add search pattern
    cmd+=" -iname \"*$SEARCH_STRING*\""
    
    # Add depth constraint
    if [[ $RECURSIVE == false ]]; then
        cmd+=" -maxdepth 1"
    elif [[ -n $MAX_DEPTH ]]; then
        cmd+=" -maxdepth $MAX_DEPTH"
    fi
    
    # Add exclusions
    for excl in "${EXCLUSIONS[@]}" "${EXTRA_EXCLUSIONS[@]}"; do
        cmd+=" ! -path \"$excl\""
    done
    
    echo "$cmd"
}

# Execute search
search_dirs() {
    local cmd
    cmd=$(find_cmd)
    
    if [[ -n $cmd ]]; then
        eval "$cmd" 2>/dev/null || {
            echo -e "${RED}Error:${NO_COLOR} Failed to execute search" >&2
            return 1
        }
    else
        echo -e "${RED}Error:${NO_COLOR} Invalid search command" >&2
        return 1
    fi
}