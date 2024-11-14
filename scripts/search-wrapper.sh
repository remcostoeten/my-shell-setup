#!/bin/bash

# Function to display help menu
display_search_help() {
    echo -e "╔════════════════════════════════════════════════════════════════╗"
    echo -e "║                        Search Wrapper Help                     ║"
    echo -e "╚════════════════════════════════════════════════════════════════╝"
    echo -e "Usage:"
    echo -e "  search [OPTIONS] PATTERN"
    echo -e "Options:"
    echo -e "  --from DIR        Start search from specified directory (default: current directory)"
    echo -e "  --depth N         Limit search depth to N levels"
    echo -e "  --ext EXT1,EXT2   Specify file extensions to search (e.g., --ext js,ts)"
    echo -e "  --folder          Search for folders instead of files"
    echo -e "  --string          Search inside files for the pattern"
    echo -e "  --max-size SIZE   Limit results to files smaller than SIZE (e.g., --max-size 1M)"
    echo -e "  --last-used       Sort results by last used (modified) time"
    echo -e "  --exclude DIRS    Exclude directories (comma-separated, e.g., --exclude node_modules,.next)"
    echo -e "Examples:"
    echo -e "  search --string 'TODO' --ext js,ts"
    echo -e "  search --folder --from src --depth 2"
    echo -e "  search --string 'function' --exclude node_modules,.next"
}

# Function to perform the search
search() {
    local dir="."
    local depth=""
    local ext=""
    local folder=""
    local string=""
    local max_size=""
    local last_used=""
    local exclude=""

    while [[ "$1" != "" ]]; do
        case $1 in
            --from) shift; dir="$1" ;;
            --depth) shift; depth="-maxdepth $1" ;;
            --ext) shift; ext="$1" ;;
            --folder) folder="-type d" ;;
            --string) shift; string="$1" ;;
            --max-size) shift; max_size="-size -$1" ;;
            --last-used) last_used="-printf '%T@ %p\n' | sort -n | cut -d' ' -f2-" ;;
            --exclude) shift; exclude="$1" ;;
            -h | --help) display_search_help; return ;;
            *) echo "Unknown option: $1"; display_search_help; return 1 ;;
        esac
        shift
    done

    local find_cmd="find $dir $depth $folder $max_size"
    if [[ -n "$ext" ]]; then
        IFS=',' read -ra exts <<< "$ext"
        for e in "${exts[@]}"; do
            find_cmd="$find_cmd -name '*.$e' -o"
        done
        find_cmd="${find_cmd% -o}"
    fi

    if [[ -n "$exclude" ]]; then
        IFS=',' read -ra excludes <<< "$exclude"
        for ex in "${excludes[@]}"; do
            find_cmd="$find_cmd -path './$ex' -prune -o"
        done
        find_cmd="${find_cmd% -o}"
    fi

    if [[ -n "$string" ]]; then
        find_cmd="$find_cmd -type f -exec grep -Hn '$string' {} +"
    else
        find_cmd="$find_cmd -print"
    fi

    if [[ -n "$last_used" ]]; then
        eval "$find_cmd $last_used"
    else
        eval "$find_cmd"
    fi
}

# Aliases
alias search='search'
alias searchhelp='display_search_help'