#!/bin/bash

# ANSI color codes
declare -A colors=(
  [RED]='\033[0;31m'
  [GREEN]='\033[0;32m'
  [YELLOW]='\033[0;33m'
  [BLUE]='\033[0;34m'
  [MAGENTA]='\033[0;35m'
  [CYAN]='\033[0;36m'
  [OFF_WHITE]='\033[0;37m'
  [RESET]='\033[0m'
)

# Function to print smooth rainbow gradient text
print_rainbow_gradient() {
    local text=$1
    local text_length=${#text}
    local color_steps=6
    local segment_length=$((text_length / color_steps))

    for ((i=0; i<text_length; i++)); do
        local segment=$((i / segment_length))
        local progress=$((i % segment_length))
        local intensity=$((255 - (progress * 255 / segment_length)))

        case $segment in
            0) printf "\033[38;2;255;${intensity};0m${text:$i:1}";;
            1) printf "\033[38;2;${intensity};255;0m${text:$i:1}";;
            2) printf "\033[38;2;0;255;${intensity}m${text:$i:1}";;
            3) printf "\033[38;2;0;${intensity};255m${text:$i:1}";;
            4) printf "\033[38;2;${intensity};0;255m${text:$i:1}";;
            5) printf "\033[38;2;255;0;${intensity}m${text:$i:1}";;
            *) printf "\033[38;2;255;0;0m${text:$i:1}";;
        esac
    done
    printf "${colors[RESET]}\n"
}

# Function to display a welcome message
welcome_message() {
  # Read the last updated date from file
    local last_updated=$(cat /home/remcostoeten/projects/zsh-setup/last_update.txt)
    local message="@remcostoeten's shell config, last updated: $last_updated"
    local total_width=64
    local message_length=${#message}
    local padding=$(( (total_width - message_length) / 2 ))
    local padding_str=$(printf '%*s' "$padding" '')

    # Get uptime in seconds
    local uptime_seconds=$(cat /proc/uptime | awk '{print $1}' | cut -d. -f1)
    
    # Convert to days, hours, minutes
    local days=$((uptime_seconds / 86400))
    local hours=$(( (uptime_seconds % 86400) / 3600 ))
    local minutes=$(( (uptime_seconds % 3600) / 60 ))

    # Construct colored uptime string
    local colored_uptime=""
    [[ $days -gt 0 ]] && colored_uptime+="${colors[RED]}$days${colors[OFF_WHITE]} days, "
    [[ $hours -gt 0 ]] && colored_uptime+="${colors[RED]}$hours${colors[OFF_WHITE]} hours, "
    colored_uptime+="${colors[RED]}$minutes${colors[OFF_WHITE]} minutes"

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

# Call the welcome message function
welcome_message
