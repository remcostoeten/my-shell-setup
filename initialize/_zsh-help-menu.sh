#!/bin/bash

# Define colors
declare -A colors=(
    ["RED"]='\033[0;31m'
    ["GREEN"]='\033[0;32m'
    ["YELLOW"]='\033[0;33m'
    ["BLUE"]='\033[0;34m'
    ["PURPLE"]='\033[0;35m'
    ["CYAN"]='\033[0;36m'
    ["ORANGE"]='\033[38;5;208m'
    ["PINK"]='\033[38;5;206m'
    ["LIME"]='\033[38;5;118m'
    ["RESET"]='\033[0m'
)

# Function to create rainbow text
rainbow_text() {
    local text="$1"
    local -a rainbow_colors
    rainbow_colors=(
        "${colors[RED]}"
        "${colors[ORANGE]}"
        "${colors[YELLOW]}"
        "${colors[GREEN]}"
        "${colors[BLUE]}"
        "${colors[PURPLE]}"
        "${colors[PINK]}"
    )
    
    local length=${#text}
    for ((i = 0; i < length; i++)); do
        local color_index=$((i % ${#rainbow_colors[@]}))
        echo -n "${rainbow_colors[$color_index]}${text:$i:1}"
    done
    echo -e "${colors[RESET]}"
}

# Function to display help menu
display_help_menu() {
    echo -e "\n${colors[BLUE]}╔══════════════════════════════════════════════════════════════════════════╗${colors[RESET]}"
    rainbow_text "                           ZSH Configuration Help                              "
    echo -e "${colors[BLUE]}╚══════════════════════════════════════════════════════════════════════════╝${colors[RESET]}"
    
    echo -e "\n${colors[LIME]}Usage:${colors[RESET]}"
    echo -e "  ${colors[CYAN]}zshhelp${colors[RESET]} - Display this help menu"
    echo -e "  ${colors[CYAN]}help${colors[RESET]} - Display this help menu"
    
    echo -e "\n${colors[LIME]}Categories:${colors[RESET]}"
    echo -e "  ${colors[PINK]}help git${colors[RESET]}      - Git commands and aliases"
    echo -e "  ${colors[ORANGE]}help docker${colors[RESET]}   - Docker commands and containers"
    echo -e "  ${colors[YELLOW]}help nvm${colors[RESET]}      - Node Version Manager commands"
    echo -e "  ${colors[GREEN]}help aliases${colors[RESET]}  - Custom aliases and shortcuts"
    echo -e "  ${colors[PURPLE]}help tasks${colors[RESET]}    - Task management system"
    echo -e "  ${colors[PINK]}help search${colors[RESET]}   - File and content search"
    echo -e "  ${colors[CYAN]}help scripts${colors[RESET]}  - Custom scripts and utilities"
}

# Function to display help for Docker commands
display_docker_help() {
    echo -e "\n${colors[BLUE]}╔═══════════════════════════════════════════════╗${colors[RESET]}"
    echo -e "    🐳 🐋 🐳 🐋 🐳 🐋 🐳 🐋 🐳 🐋 🐳 🐋 🐳 🐋 🐳"
    echo -e "     ____             _             "
    echo -e "    |  _ \\  ___   ___| | _____ _ __ "
    echo -e "    | | | |/ _ \\ / __| |/ / _ \\ '__|"
    echo -e "    | |_| | (_) | (__|   <  __/ |   "
    echo -e "    |____/ \\___/ \\___|_|\\_\\___|_|   "
    echo -e "    🐳 🐋 🐳 🐋 🐳 🐋 🐳 🐋 🐳 🐋 🐳 🐋 🐳 🐋 🐳"
    echo -e "${colors[BLUE]}╚═════════════════════════════════════════════╝${colors[RESET]}"

    echo -e "\n${colors[LIME]}Database Management:${colors[RESET]}"
    echo -e "  ${colors[CYAN]}createdb${colors[RESET]}      - Create a new PostgreSQL database container"
    echo -e "  ${colors[CYAN]}copydockerdb${colors[RESET]}  - Copy database credentials to clipboard"
    echo -e "  ${colors[CYAN]}spinup${colors[RESET]}        - Spin up a new PostgreSQL database with custom config"
    
    echo -e "\n${colors[ORANGE]}Container Lifecycle:${colors[RESET]}"
    echo -e "  ${colors[YELLOW]}dstart${colors[RESET]}        - Start containers (docker-compose up)"
    echo -e "  ${colors[YELLOW]}dstartd${colors[RESET]}       - Start containers in detached mode"
    echo -e "  ${colors[YELLOW]}dstop${colors[RESET]}         - Stop and remove containers"
    echo -e "  ${colors[YELLOW]}dshow${colors[RESET]}         - Show running containers"
    echo -e "  ${colors[YELLOW]}drestart${colors[RESET]}      - Restart Docker service"
    
    echo -e "\n${colors[PINK]}Container Management:${colors[RESET]}"
    echo -e "  ${colors[PURPLE]}stopdocker${colors[RESET]}    - Stop all running containers"
    echo -e "  ${colors[PURPLE]}rmdocker${colors[RESET]}      - Remove all stopped containers"
    echo -e "  ${colors[PURPLE]}rmcontainer${colors[RESET]}   - Remove individual container (interactive)"
    echo -e "  ${colors[PURPLE]}rmall${colors[RESET]}         - Remove all containers and images"

    echo -e "\n${colors[GREEN]}System Operations:${colors[RESET]}"
    echo -e "  ${colors[CYAN]}reinstall${colors[RESET]}     - Reinstall Docker completely"
    echo -e "  ${colors[CYAN]}rmpg${colors[RESET]}          - Remove PostgreSQL"
    echo -e "  ${colors[CYAN]}resetall${colors[RESET]}      - Remove all and reinstall Docker + PostgreSQL"

    echo -e "\n${colors[YELLOW]}Additional Features:${colors[RESET]}"
    echo -e "  ${colors[GREEN]}- Interactive menu with fuzzy search${colors[RESET]}"
    echo -e "  ${colors[GREEN]}- Automatic backup of docker-compose.yml${colors[RESET]}"
    echo -e "  ${colors[GREEN]}- Clipboard integration for credentials${colors[RESET]}"
    echo -e "  ${colors[GREEN]}- Custom PostgreSQL configuration${colors[RESET]}"
}

# Update display_git_help function
display_git_help() {
    echo -e "\n${colors[BLUE]}╔══════════════════════════════════════════════════════════════════════════╗${colors[RESET]}"
    rainbow_text "                           Git Command Center                                  "
    echo -e "${colors[BLUE]}╚══════════════════════════════════════════════════════════════════════════╝${colors[RESET]}"
    echo -e "\n${colors[LIME]}Basic Commands:${colors[RESET]}"
    echo -e "  ${colors[CYAN]}g${colors[RESET]}            - Shortcut for git"
    echo -e "  ${colors[CYAN]}status${colors[RESET]}       - Check repository status"
    echo -e "  ${colors[CYAN]}add${colors[RESET]}          - Stage changes"
    echo -e "  ${colors[CYAN]}commit${colors[RESET]}       - Commit changes"
    echo -e "  ${colors[CYAN]}gcm${colors[RESET]}          - Commit and push (usage: gcm \"your message\")"
    
    echo -e "\n${colors[ORANGE]}Quick Commit Example:${colors[RESET]}"
    echo -e "  ${colors[YELLOW]}gcm \"feat: add new feature\"${colors[RESET]} - Commits and pushes in one command"
    
    # Rest of the existing git help content...
    echo -e "\n${colors[ORANGE]}Branch Operations:${colors[RESET]}"
    echo -e "  ${colors[YELLOW]}checkout${colors[RESET]}     - Switch branches"
    echo -e "  ${colors[YELLOW]}newbranch${colors[RESET]}    - Create new branch"
    echo -e "  ${colors[YELLOW]}branch${colors[RESET]}       - List branches"
    
    echo -e "\n${colors[PINK]}Remote Operations:${colors[RESET]}"
    echo -e "  ${colors[PURPLE]}push${colors[RESET]}         - Push changes"
    echo -e "  ${colors[PURPLE]}pull${colors[RESET]}         - Pull changes"
    echo -e "  ${colors[PURPLE]}pushf${colors[RESET]}        - Force push with lease"
    echo -e "  ${colors[PURPLE]}remote${colors[RESET]}       - Show remotes"
    echo -e "  ${colors[PURPLE]}copyremote${colors[RESET]}   - Copy remote URL"
    echo -e "  ${colors[PURPLE]}clone${colors[RESET]}        - Clone repository"
}

display_nvm_help() {
    echo -e "\n${colors[BLUE]}╔══════════════════════════════════════════════════════════════════════════╗${colors[RESET]}"
    rainbow_text "                           Node Version Manager                                "
    echo -e "${colors[BLUE]}╚══════════════════════════════════════════════════════════════════════════╝${colors[RESET]}"

    echo -e "\n${colors[LIME]}NVM Commands:${colors[RESET]}"
    echo -e "  ${colors[CYAN]}nvm install${colors[RESET]}   - Install a specific Node.js version"
    echo -e "  ${colors[CYAN]}nvm use${colors[RESET]}       - Use a specific Node.js version"
    echo -e "  ${colors[CYAN]}nvm ls${colors[RESET]}        - List installed Node.js versions"
    echo -e "  ${colors[CYAN]}nvm ls-remote${colors[RESET]} - List available Node.js versions"
    echo -e "  ${colors[CYAN]}nvm alias${colors[RESET]}     - Create version alias"
}

display_aliases_help() {
    echo -e "\n${colors[BLUE]}╔══════════════════════════════════════════════════════════════════════════╗${colors[RESET]}"
    rainbow_text "                           Custom Aliases                                      "
    echo -e "${colors[BLUE]}╚══════════════════════════════════════════════════════════════════════════╝${colors[RESET]}"

    echo -e "\n${colors[LIME]}Terminal Operations:${colors[RESET]}"
    echo -e "  ${colors[CYAN]}xx${colors[RESET]}           - Exit terminal"
    echo -e "  ${colors[CYAN]}cc${colors[RESET]}           - Clear terminal"
    echo -e "  ${colors[CYAN]}ll${colors[RESET]}           - List files with details"
    echo -e "  ${colors[CYAN]}l${colors[RESET]}            - List files"
}

# Function to display help for search commands
display_search_help() {
    echo -e "\n${colors[BLUE]}╔══════════════════════════════════════════════════════════════════════════╗${colors[RESET]}"
    rainbow_text "                           Search Tools                                        "
    echo -e "${colors[BLUE]}╚══════════════════════════════════════════════════════════════════════════╝${colors[RESET]}"

    echo -e "\n${colors[LIME]}Search Options:${colors[RESET]}"
    echo -e "  ${colors[CYAN]}--from DIR${colors[RESET]}    - Start search from directory"
    echo -e "  ${colors[CYAN]}--depth N${colors[RESET]}     - Limit search depth"
    echo -e "  ${colors[CYAN]}--ext EXT${colors[RESET]}     - Filter by extension"
    echo -e "  ${colors[CYAN]}--folder${colors[RESET]}      - Search folders only"
    echo -e "  ${colors[CYAN]}--string${colors[RESET]}      - Search file contents"
    echo -e "  ${colors[CYAN]}--max-size${colors[RESET]}    - Limit file size"
    echo -e "  ${colors[CYAN]}--last-used${colors[RESET]}   - Sort by last modified"
}

# Function to display help for task management
display_tasks_help() {
    echo -e "\n${colors[BLUE]}╔══════════════════════════════════════════════════════════════════════════╗${colors[RESET]}"
    rainbow_text "                           Task Management                                     "
    echo -e "${colors[BLUE]}╚══════════════════════════════════════════════════════════════════════════╝${colors[RESET]}"

    echo -e "\n${colors[LIME]}Task Commands:${colors[RESET]}"
    echo -e "  ${colors[CYAN]}task 'description' --by 'time'${colors[RESET]} - Add new task"
    echo -e "  ${colors[CYAN]}task --list${colors[RESET]}                    - List all tasks"
    echo -e "  ${colors[CYAN]}task remove <number>${colors[RESET]}           - Remove task"
    echo -e "  ${colors[CYAN]}task remove-all${colors[RESET]}                - Clear all tasks"
}

# Function to display help for scripts
display_scripts_help() {
    echo -e "\n${colors[BLUE]}╔══════════════════════════════════════════════════════════════════════════╗${colors[RESET]}"
    rainbow_text "                           Custom Scripts & Utilities                          "
    echo -e "${colors[BLUE]}╚══════════════════════════════════════════════════════════════════════════╝${colors[RESET]}"

    echo -e "\n${colors[LIME]}Conventional Commits (cz):${colors[RESET]}"
    echo -e "  ${colors[CYAN]}cz${colors[RESET]}                     - Start conventional commit process"
    echo -e "\n${colors[ORANGE]}Available Commit Types:${colors[RESET]}"
    echo -e "  ${colors[PURPLE]}feat${colors[RESET]}     ➕ A new feature"
    echo -e "  ${colors[PURPLE]}fix${colors[RESET]}      🔧 A bug fix"
    echo -e "  ${colors[PURPLE]}docs${colors[RESET]}     📚 Documentation changes"
    echo -e "  ${colors[PURPLE]}style${colors[RESET]}    💅 Code style changes"
    echo -e "  ${colors[PURPLE]}refactor${colors[RESET]} ♻️  Code refactoring"
    echo -e "  ${colors[PURPLE]}perf${colors[RESET]}     ⚡️ Performance improvements"
    echo -e "  ${colors[PURPLE]}test${colors[RESET]}     🧪 Testing related changes"
    echo -e "  ${colors[PURPLE]}build${colors[RESET]}    🏗️  Build system changes"
    echo -e "  ${colors[PURPLE]}ci${colors[RESET]}       👷 CI/CD changes"
    echo -e "  ${colors[PURPLE]}chore${colors[RESET]}    🧹 Other changes"

    echo -e "\n${colors[LIME]}Secret Generators:${colors[RESET]}"
    echo -e "  ${colors[CYAN]}jwt${colors[RESET]}      - Generate JWT secret"
    echo -e "  ${colors[CYAN]}secret${colors[RESET]}   - Generate generic secret"
    
    echo -e "\n${colors[YELLOW]}Secret Options:${colors[RESET]}"
    echo -e "  ${colors[GREEN]}JWT Length:${colors[RESET]}        64 characters"
    echo -e "  ${colors[GREEN]}Secret Length:${colors[RESET]}     32 characters"
    echo -e "  ${colors[GREEN]}Format:${colors[RESET]}            Automatically copies to clipboard"
    echo -e "  ${colors[GREEN]}Output Format:${colors[RESET]}"
    echo -e "    JWT:    ${colors[GRAY]}JWT_SECRET=<generated-secret>${colors[RESET]}"
    echo -e "    Secret: ${colors[GRAY]}SECRET=<generated-secret>${colors[RESET]}"
}

# Function to display help for scripts directory
display_scripts_directory_help() {
    echo -e "\n${colors[BLUE]}╔══════════════════════════════════════════════════════════════════════════╗${colors[RESET]}"
    rainbow_text "                           Available Scripts                                     "
    echo -e "${colors[BLUE]}╚══════════════════════════════════════════════════════════════════════════╝${colors[RESET]}"

    echo -e "\n${colors[LIME]}Audio Recording:${colors[RESET]}"
    echo -e "  ${colors[CYAN]}voice${colors[RESET]}         - Start voice recording script"
    echo -e "  ${colors[CYAN]}voice2clip${colors[RESET]}    - Convert speech to clipboard text"

    echo -e "\n${colors[LIME]}Docker Management:${colors[RESET]}"
    echo -e "  ${colors[CYAN]}db${colors[RESET]}           - Interactive Docker management menu"
    echo -e "  ${colors[CYAN]}spinup${colors[RESET]}       - Set up new PostgreSQL container"

    echo -e "\n${colors[LIME]}Git Tools:${colors[RESET]}"
    echo -e "  ${colors[CYAN]}cz${colors[RESET]}           - Conventional commit helper"
    echo -e "  ${colors[CYAN]}gcm${colors[RESET]}          - Quick commit and push"

    echo -e "\n${colors[LIME]}Development:${colors[RESET]}"
    echo -e "  ${colors[CYAN]}restart${colors[RESET]}      - Clean and restart dev server"
    echo -e "  ${colors[CYAN]}dev${colors[RESET]}          - Start development environment"

    echo -e "\n${colors[LIME]}Utilities:${colors[RESET]}"
    echo -e "  ${colors[CYAN]}search${colors[RESET]}       - Advanced file/directory search"
    echo -e "  ${colors[CYAN]}jwt${colors[RESET]}          - Generate JWT secret"
    echo -e "  ${colors[CYAN]}secret${colors[RESET]}       - Generate generic secret"

    echo -e "\n${colors[LIME]}Location:${colors[RESET]}"
    echo -e "  Scripts are stored in: ${colors[YELLOW]}~/projects/zsh-setup/scripts/${colors[RESET]}"
}

# Update the main zsh_help function to include the new option
zsh_help() {
    case $1 in
        git) display_git_help ;;
        docker) display_docker_help ;;
        nvm) display_nvm_help ;;
        aliases) display_aliases_help ;;
        tasks) display_tasks_help ;;
        search) display_search_help ;;
        scripts) display_scripts_directory_help ;;
        *) display_help_menu ;;
    esac
}

alias zshhelp='zsh_help'
alias help='zsh_help'