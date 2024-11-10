#!/bin/zsh

# Print current path function
print_current_path() {
    # Get current path and replace home directory with ~
    local current_path=${PWD/#$HOME/\~}
    
    # Colors
    local colors=(
        "196" # red
        "208" # orange
        "226" # yellow
        "46"  # green
        "51"  # cyan
        "21"  # blue
        "165" # purple
    )
    
    # Split path into segments and print with colors
    local parts=(${(s:/:)current_path})
    local output=""
    local i=1
    
    for part in $parts; do
        if [[ -n $output ]]; then
            output+=" %F{240}→%f "
        fi
        output+="%F{${colors[$((i % 7 + 1))]}}$part%f"
        ((i++))
    done
    
    print -P $output
}