#!/bin/bash

# Define color codes
declare -A colors=(
    [RED]='\033[0;31m'
    [GREEN]='\033[0;32m'
    [YELLOW]='\033[0;33m'
    [BLUE]='\033[0;34m'
    [PURPLE]='\033[0;35m'
    [CYAN]='\033[0;36m'
    [OFF_WHITE]='\033[0;37m'
    [RESET]='\033[0m'
)

# Function to print rainbow gradient
print_rainbow_gradient() {
    local text="$1"
    local length=${#text}
    for ((i=0; i<length; i++)); do
        local char="${text:$i:1}"
        case $((i % 6)) in
            0) echo -ne "${colors[RED]}$char";;
            1) echo -ne "${colors[YELLOW]}$char";;
            2) echo -ne "${colors[GREEN]}$char";;
            3) echo -ne "${colors[CYAN]}$char";;
            4) echo -ne "${colors[BLUE]}$char";;
            5) echo -ne "${colors[PURPLE]}$char";;
        esac
    done
    echo -e "${colors[RESET]}"
}

# Function to display welcome message
welcome_message() {
    local uptime=$(uptime -p)
    local colored_uptime="${colors[GREEN]}$uptime${colors[RESET]}"
    
    # Read the last updated date from file
    local last_updated=$(cat /home/remcostoeten/projects/zsh-setup/last_update.txt)
    
    local message="@remcostoeten's shell config, last updated: $last_updated"
    local padding_length=$(( (80 - ${#message}) / 2 ))
    local padding_str=$(printf '%*s' "$padding_length")
    
    echo -e "${colors[OFF_WHITE]}Good $(get_greeting)! $(date +"%H:%M") Uptime: $colored_uptime${colors[RESET]}"
    print_rainbow_gradient "╔════════════════════════════════════════════════════════════════╗"
    print_rainbow_gradient "${padding_str}${message}${padding_str}"
    print_rainbow_gradient "╚════════════════════════════════════════════════════════════════╝"
    echo -e "${colors[OFF_WHITE]}type '${colors[RED]}zshhelp${colors[OFF_WHITE]}' or '${colors[RED]}help${colors[OFF_WHITE]}' for full zsh-helper menu${colors[RESET]}"
}

# Function to get the appropriate greeting based on time of day
get_greeting() {
    local hour=$(date +"%H")
    if [ $hour -lt 12 ]; then
        echo "morning"
    elif [ $hour -lt 18 ]; then
        echo "afternoon"
    else
        echo "evening"
    fi
}
