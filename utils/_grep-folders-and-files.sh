#!/usr/bin/env zsh

search() {
    local pattern=""
    local search_dir="."
    local depth=3
    local extensions=("ts" "tsx" "js" "jsx" "py" "scss" "css" "json" "mdx")
    local search_type="filename"
    local max_size=""
    local sort_by_last_used=false
    local exclude_dirs=("node_modules" ".next" ".git" ".tmp")

    # Color definitions
    local COLOR_RESET="\033[0m"
    local COLOR_BOLD="\033[1m"
    local COLOR_BLUE="\033[34m"
    local COLOR_GREEN="\033[32m"
    local COLOR_YELLOW="\033[33m"
    local COLOR_RED="\033[31m"

    # Parse options
    while [[ "$#" -gt 0 ]]; do
        case $1 in
            --from) search_dir="$2"; shift ;;
            --depth) depth="$2"; shift ;;
            --ext) IFS=',' read -rA extensions <<< "$2"; shift ;;
            --folder) search_type="folder" ;;
            --string) search_type="content" ;;
            --max-size) max_size="$2"; shift ;;
            --last-used) sort_by_last_used=true ;;
            --help) show_help; return 0 ;;
            *) 
                if [[ -z "$pattern" ]]; then
                    pattern="$1"
                else
                    pattern="$pattern $1"
                fi
            ;;
        esac
        shift
    done

    if [[ -z "$pattern" ]]; then
        echo -e "${COLOR_BOLD}${COLOR_RED}Error:${COLOR_RESET} Search pattern is required."
        show_help
        return 1
    fi

    echo -e "${COLOR_BOLD}${COLOR_BLUE}Search Parameters:${COLOR_RESET}"
    echo -e "  Pattern: $pattern"
    echo -e "  Search type: $search_type"
    echo -e "  Directory: $search_dir"
    echo -e "  Depth: $depth"
    echo -e "  Extensions: ${extensions[*]}"
    [[ -n "$max_size" ]] && echo -e "  Max size: $max_size"
    $sort_by_last_used && echo -e "  Sorting by last used"

    local results=()

    case $search_type in
        filename)
            echo -e "\n${COLOR_BOLD}${COLOR_GREEN}Searching for files with '$pattern' in the name:${COLOR_RESET}"
            if command -v fd >/dev/null 2>&1; then
                results=($(fd --color always -H -d "$depth" -t f "$pattern" "$search_dir" \
                    ${extensions:+${extensions[@]/#/--extension }} \
                    ${exclude_dirs:+${exclude_dirs[@]/#/-E }} \
                    ${max_size:+-S -$max_size}))
            else
                local find_cmd="find '$search_dir' -maxdepth $depth -type f"
                local name_pattern=""
                for ext in "${extensions[@]}"; do
                    name_pattern+=" -o -iname '*$pattern*.$ext'"
                done
                find_cmd+=" \( -false ${name_pattern} \)"
                for dir in "${exclude_dirs[@]}"; do
                    find_cmd+=" -not -path '*/$dir/*'"
                done
                [[ -n "$max_size" ]] && find_cmd+=" -size -$max_size"
                results=($(eval "$find_cmd"))
            fi
            ;;
        folder)
            echo -e "\n${COLOR_BOLD}${COLOR_GREEN}Searching for folders with '$pattern' in the name:${COLOR_RESET}"
            if command -v fd >/dev/null 2>&1; then
                results=($(fd --color always -H -d "$depth" -t d "$pattern" "$search_dir" \
                    ${exclude_dirs:+${exclude_dirs[@]/#/-E }}))
            else
                local find_cmd="find '$search_dir' -maxdepth $depth -type d -iname '*$pattern*'"
                for dir in "${exclude_dirs[@]}"; do
                    find_cmd+=" -not -path '*/$dir/*'"
                done
                results=($(eval "$find_cmd"))
            fi
            ;;
        content)
            echo -e "\n${COLOR_BOLD}${COLOR_GREEN}Searching for files containing '$pattern':${COLOR_RESET}"
            if command -v rg >/dev/null 2>&1; then
                results=($(rg --color always -l --max-depth "$depth" "$pattern" "$search_dir" \
                    ${extensions:+${extensions[@]/#/-g '*.'}} \
                    ${exclude_dirs:+${exclude_dirs[@]/#/-g '!'}} \
                    ${max_size:+--max-filesize $max_size}))
            else
                local grep_cmd="grep -r -l --color=always '$pattern' '$search_dir'"
                for dir in "${exclude_dirs[@]}"; do
                    grep_cmd+=" --exclude-dir='$dir'"
                done
                for ext in "${extensions[@]}"; do
                    grep_cmd+=" --include='*.$ext'"
                done
                results=($(eval "$grep_cmd"))
            fi
            ;;
    esac

    if [[ ${#results[@]} -eq 0 ]]; then
        echo -e "${COLOR_YELLOW}No results found.${COLOR_RESET}"
    else
        if $sort_by_last_used; then
            print -l "${results[@]}" | xargs -d '\n' ls -lt --color=always | awk '{$1=$2=$3=$4=$5=$6=$7=$8=""; print substr($0,9)}'
        else
            print -l "${results[@]}"
        fi
        echo -e "\n${COLOR_BLUE}Total results found: ${#results[@]}${COLOR_RESET}"
    fi
}

show_help() {
    echo -e "${COLOR_BOLD}${COLOR_BLUE}Search Usage:${COLOR_RESET}"
    echo -e "  search [OPTIONS] PATTERN\n"
    
    echo -e "${COLOR_BOLD}${COLOR_YELLOW}Options:${COLOR_RESET}"
    echo -e "  ${COLOR_GREEN}--from DIR${COLOR_RESET}      Start search from specified directory ${COLOR_BLUE}(default: current directory)${COLOR_RESET}"
    echo -e "  ${COLOR_GREEN}--depth N${COLOR_RESET}       Limit search depth to N levels ${COLOR_BLUE}(default: 3)${COLOR_RESET}"
    echo -e "  ${COLOR_GREEN}--ext EXT1,EXT2${COLOR_RESET} Specify file extensions to search ${COLOR_BLUE}(default: ts,tsx,js,jsx,py,scss,css,json,mdx)${COLOR_RESET}"
    echo -e "  ${COLOR_GREEN}--folder${COLOR_RESET}        Search for folders instead of files"
    echo -e "  ${COLOR_GREEN}--string${COLOR_RESET}        Search inside files for the pattern"
    echo -e "  ${COLOR_GREEN}--max-size SIZE${COLOR_RESET} Limit results to files smaller than SIZE ${COLOR_BLUE}(e.g., 100M, 1G)${COLOR_RESET}"
    echo -e "  ${COLOR_GREEN}--last-used${COLOR_RESET}     Sort results by last used (modified) time"
    echo -e "  ${COLOR_GREEN}--help${COLOR_RESET}          Show this help message\n"
    
    echo -e "${COLOR_BOLD}${COLOR_YELLOW}Examples:${COLOR_RESET}"
    echo -e "  ${COLOR_GREEN}search sidebar${COLOR_RESET}                     ${COLOR_BLUE}# Search for files with 'sidebar' in the name${COLOR_RESET}"
    echo -e "  ${COLOR_GREEN}search --folder core${COLOR_RESET}               ${COLOR_BLUE}# Search for folders with 'core' in the name${COLOR_RESET}"
    echo -e "  ${COLOR_GREEN}search --string \"GOOGLE\" --ext py,rb${COLOR_RESET}  ${COLOR_BLUE}# Search for \"GOOGLE\" in Python and Ruby files${COLOR_RESET}"
    echo -e "  ${COLOR_GREEN}search log --max-size 10M --last-used${COLOR_RESET} ${COLOR_BLUE}# Find log files under 10MB, sorted by last modified${COLOR_RESET}"
    
    echo -e "\n${COLOR_BOLD}${COLOR_YELLOW}Default Behavior:${COLOR_RESET}"
    echo -e "  - Searches for filenames by default"
    echo -e "  - Ignores node_modules, .next, .git, .tmp directories"
    echo -e "  - Searches in ts, tsx, js, jsx, py, scss, css, json, mdx files by default"
    
    echo -e "\n${COLOR_BOLD}${COLOR_BLUE}Pro Tip:${COLOR_RESET} Use quotes around patterns with spaces or special characters."
}

# Create the alias
alias search='search'
