#!/bin/bash

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
NO_COLOR='\033[0m'

# Default values
START_DIR="/"
SEARCH_STRING=""
EXTRA_EXCLUSIONS=()
RECURSIVE=true
MAX_DEPTH=""
MAX_NAME_LENGTH=""
MAX_FOLDER_SIZE=""

# Base exclusions
EXCLUSIONS=(
    "*/node_modules/*"
    "*/build/*"
    "*/dist/*"
    "*/.git/*"
    "*/target/*"
)

usage() {
    echo -e "${CYAN}╔══════════════════════════════════════════════════════════════════════════╗${NO_COLOR}"
    echo -e "${CYAN}║                              Search Directories                           ║${NO_COLOR}"
    echo -e "${CYAN}╚══════════════════════════════════════════════════════════════════════════╝${NO_COLOR}"
    echo -e "${GREEN}Usage:${NO_COLOR} search-dirs ${GREEN}-s <search-string>${NO_COLOR} [${YELLOW}options${NO_COLOR}]"
    echo -e "${CYAN}Options:${NO_COLOR}"
    echo -e "  ${GREEN}-s <search-string>${NO_COLOR}     Search string (required)"
    echo -e "  ${YELLOW}-d <starting-dir>${NO_COLOR}     Starting directory (default: /)"
    echo -e "  ${YELLOW}-n${NO_COLOR}                    Non-recursive search"
    echo -e "  ${YELLOW}-l <max-depth>${NO_COLOR}        Maximum depth"
    echo -e "  ${YELLOW}-e <paths>${NO_COLOR}            Comma-separated list of paths to exclude"
    echo -e "  ${YELLOW}-L <max-name-length>${NO_COLOR}  Maximum name length"
    echo -e "  ${YELLOW}-S <max-folder-size>${NO_COLOR}  Maximum folder size"
    echo -e "  ${YELLOW}-h${NO_COLOR}                    Show this help"
    echo
    echo -e "${GREEN}Examples:${NO_COLOR}"
    echo -e "  ${CYAN}1. Directory Search:${NO_COLOR}"
    echo "     search-dirs -s 'foldername'              # Find directories named 'foldername'"
    echo "     search-dirs -s 'config' -d /etc          # Search in /etc for directories named 'config'"
    echo "     search-dirs -s 'config' -d /etc -l 2     # Limit search depth to 2 levels"
    echo
    echo -e "  ${CYAN}2. Excluding Paths:${NO_COLOR}"
    echo "     search-dirs -s 'src' -e 'node_modules,dist'  # Exclude 'node_modules' and 'dist' directories"
    echo
    echo -e "  ${CYAN}3. Advanced Usage:${NO_COLOR}"
    echo "     search-dirs -s 'src' -d ~/projects -n        # Non-recursive search in ~/projects"
    echo "     search-dirs -s 'src' -d ~/projects -L 10     # Limit directory name length to 10 characters"
    echo "     search-dirs -s 'src' -d ~/projects -S 100M   # Limit folder size to 100MB"
    echo
    echo -e "${GREEN}Commands:${NO_COLOR}"
    echo "  search-dirs       Execute search"
    echo "  search-help       Show this help"
}

find_cmd() {
    local cmd="find \"$START_DIR\" -type d"
    cmd+=" -iname \"*$SEARCH_STRING*\""
    
    if [[ $RECURSIVE == false ]]; then
        cmd+=" -maxdepth 1"
    elif [[ -n $MAX_DEPTH ]]; then
        cmd+=" -maxdepth $MAX_DEPTH"
    fi
    
    for excl in "${EXCLUSIONS[@]}" "${EXTRA_EXCLUSIONS[@]}"; do
        cmd+=" ! -path \"$excl\""
    done
    
    echo "$cmd"
}

search_dirs() {
    # Parse arguments
    while getopts "s:d:e:nl:L:S:h" opt; do
        case $opt in
            s) SEARCH_STRING="$OPTARG" ;;
            d) START_DIR="$OPTARG" ;;
            e) EXTRA_EXCLUSIONS+=("$OPTARG") ;;
            n) RECURSIVE=false ;;
            l) MAX_DEPTH="$OPTARG" ;;
            L) MAX_NAME_LENGTH="$OPTARG" ;;
            S) MAX_FOLDER_SIZE="$OPTARG" ;;
            h) usage; return 0 ;;
            *) usage; return 1 ;;
        esac
    done

    # Validate input
    if [[ -z $SEARCH_STRING ]]; then
        echo -e "${RED}Error:${NO_COLOR} Search string (-s) is required."
        usage
        return 1
    fi

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

# Only run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    search_dirs "$@"
fi

# Make functions available when sourced
alias search-dirs='search_dirs'
alias search-help='usage'