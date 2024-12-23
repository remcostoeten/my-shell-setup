#!/bin/bash

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default settings
EXCLUDES=(".git" "node_modules" "build" "dist" ".*")
DEPTH=99
SEARCH_PATH="."
IS_FILE_SEARCH=false
IS_INSIDE_SEARCH=false
INSIDE_QUERY=""

# Update the usage function
usage() {
    echo -e "${BLUE}╔════════════════════ File Search Helper ════════════════════╗${NC}"
    echo -e "${BLUE}║${NC} Find files, directories and content with ease         ${BLUE}║${NC}"
    echo -e "${BLUE}╚══════════════════════════════════════════════════════════╝${NC}"
    echo
    echo -e "${GREEN}Usage:${NC}"
    echo "  search [options] 'query'"
    echo
    echo -e "${GREEN}Options:${NC}"
    echo "  --depth N              Set search depth (default: $DEPTH)"
    echo "  --exclude paths        Skip paths (comma-separated)"
    echo "  --file                Search for files only"
    echo "  --inside 'text'        Search file contents"
    echo "  --help                Show this help"
    echo
    echo -e "${GREEN}Search Types:${NC}"
    echo -e "  ${YELLOW}1. Directory Search:${NC}"
    echo "     search 'foldername'              # Find directories"
    echo "     search 'config' --depth 2        # Shallow directory search"
    echo
    echo -e "  ${YELLOW}2. File Search:${NC}"
    echo "     search 'file.txt' --file         # Find files"
    echo "     search '*.js' --file             # Find by pattern"
    echo
    echo -e "  ${YELLOW}3. Content Search:${NC}"
    echo "     search --inside 'function'       # Search in all files"
    echo "     search '*.js' --inside 'react'   # Search in JS files"
    echo
    echo -e "  ${YELLOW}4. Advanced Usage:${NC}"
    echo "     search 'src' --exclude 'node_modules,dist'"
    echo "     search '*.ts' --file --depth 3 --inside 'interface'"
    echo
    echo -e "${GREEN}Commands:${NC}"
    echo "  search       Execute search"
    echo "  searchhelp   Show this help"
}

do_search() {
    # Parse command line arguments
    local QUERY=""
    while [[ "$#" -gt 0 ]]; do
        case $1 in
            --depth)
                if [[ ! $2 =~ ^[0-9]+$ ]]; then
                    echo -e "${RED}Error: Depth must be a number${NC}"
                    return 1
                fi
                DEPTH="$2"
                shift
                ;;
            --exclude)
                if [[ -z "$2" ]]; then
                    echo -e "${RED}Error: --exclude requires a value${NC}"
                    return 1
                fi
                IFS=',' read -r -a EXCLUDES <<< "$2"
                shift
                ;;
            --file)
                IS_FILE_SEARCH=true
                ;;
            --inside)
                IS_INSIDE_SEARCH=true
                if [[ -z "$2" ]]; then
                    echo -e "${RED}Error: --inside requires a search string${NC}"
                    return 1
                fi
                INSIDE_QUERY="$2"
                shift
                ;;
            --help)
                usage
                return 0
                ;;
            *)
                if [[ -z "$QUERY" ]]; then
                    QUERY="$1"
                else
                    echo -e "${RED}Error: Multiple queries provided${NC}"
                    return 1
                fi
                ;;
        esac
        shift
    done

    # Validate query
    if [[ -z "$QUERY" ]]; then
        echo -e "${RED}Error: Query not provided${NC}"
        usage
        return 1
    fi

    # Construct exclude options
    local EXCLUDE_OPTS=""
    for EXCLUDE in "${EXCLUDES[@]}"; do
        EXCLUDE_OPTS+=" -not -path \"*/$EXCLUDE/*\""
    done

    # Build and execute search command
    local find_cmd="find \"$SEARCH_PATH\""
    [[ $DEPTH -gt 0 ]] && find_cmd+=" -maxdepth $DEPTH"
    
    if $IS_INSIDE_SEARCH; then
        echo -e "${BLUE}Searching for text '${YELLOW}$INSIDE_QUERY${BLUE}' in files...${NC}"
        if $IS_FILE_SEARCH; then
            find_cmd+=" -type f $EXCLUDE_OPTS -name \"$QUERY\""
        else
            find_cmd+=" -type f $EXCLUDE_OPTS"
        fi
        eval "$find_cmd" | while read -r file; do
            if grep -l "$INSIDE_QUERY" "$file" >/dev/null 2>&1; then
                echo -e "${GREEN}Found in:${NC} $file"
                grep --color=always -n "$INSIDE_QUERY" "$file"
            fi
        done
    else
        if $IS_FILE_SEARCH; then
            echo -e "${BLUE}Searching for files named '${YELLOW}$QUERY${BLUE}'...${NC}"
            find_cmd+=" -type f"
        else
            echo -e "${BLUE}Searching for directories named '${YELLOW}$QUERY${BLUE}'...${NC}"
            find_cmd+=" -type d"
        fi
        find_cmd+=" $EXCLUDE_OPTS -name \"$QUERY\""
        eval "$find_cmd" | while read -r result; do
            echo -e "${GREEN}Found:${NC} $result"
        done
    fi
}

# Only run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    do_search "$@"
fi

alias searchhelp='usage'
# Make functions available when sourced
alias search='do_search'