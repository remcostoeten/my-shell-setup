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
    echo -e "${CYAN}Usage:${NO_COLOR} search-dirs ${GREEN}-s <search-string>${NO_COLOR} [${YELLOW}options${NO_COLOR}]"
    echo -e "${CYAN}Options:${NO_COLOR}"
    echo -e "  ${GREEN}-s <search-string>${NO_COLOR}     Search string (required)"
    echo -e "  ${YELLOW}-d <starting-dir>${NO_COLOR}     Starting directory (default: /)"
    echo -e "  ${YELLOW}-n${NO_COLOR}                    Non-recursive search"
    echo -e "  ${YELLOW}-l <max-depth>${NO_COLOR}        Maximum depth"
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
    while getopts "s:d:e:nl:L:S:" opt; do
        case $opt in
            s) SEARCH_STRING="$OPTARG" ;;
            d) START_DIR="$OPTARG" ;;
            e) EXTRA_EXCLUSIONS+=("$OPTARG") ;;
            n) RECURSIVE=false ;;
            l) MAX_DEPTH="$OPTARG" ;;
            L) MAX_NAME_LENGTH="$OPTARG" ;;
            S) MAX_FOLDER_SIZE="$OPTARG" ;;
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