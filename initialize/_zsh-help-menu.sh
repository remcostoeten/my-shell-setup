#!/bin/bash

# Function to display help menu
display_help_menu() {
    echo -e "${colors[BLUE]}╔════════════════════════════════════════════════════════════════╗${colors[RESET]}"
    echo -e "${colors[BLUE]}║                   ZSH Configuration Help                       ║${colors[RESET]}"
    echo -e "${colors[BLUE]}╚════════════════════════════════════════════════════════════════╝${colors[RESET]}"
    echo -e "${colors[GREEN]}Usage:${colors[RESET]}"
    echo -e "  ${colors[YELLOW]}zshhelp${colors[RESET]} - Display this help menu"
    echo -e "  ${colors[YELLOW]}help${colors[RESET]} - Display this help menu"
    echo -e "${colors[GREEN]}Categories:${colors[RESET]}"
    echo -e "  ${colors[YELLOW]}git${colors[RESET]} - Git commands and aliases"
    echo -e "  ${colors[YELLOW]}nvm${colors[RESET]} - Node Version Manager commands"
    echo -e "  ${colors[YELLOW]}aliases${colors[RESET]} - Custom aliases"
    echo -e "  ${colors[YELLOW]}colorize${colors[RESET]} - Colorize output"
    echo -e "  ${colors[YELLOW]}tasks${colors[RESET]} - Task management commands"
    echo -e "  ${colors[YELLOW]}search${colors[RESET]} - Search commands and aliases"
    echo -e "${colors[GREEN]}Examples:${colors[RESET]}"
    echo -e "  ${colors[YELLOW]}zshhelp git${colors[RESET]} - Display help for Git commands"
    echo -e "  ${colors[YELLOW]}zshhelp nvm${colors[RESET]} - Display help for NVM commands"
    echo -e "  ${colors[YELLOW]}zshhelp aliases${colors[RESET]} - Display help for custom aliases"
    echo -e "  ${colors[YELLOW]}zshhelp colorize${colors[RESET]} - Display help for colorize output"
    echo -e "  ${colors[YELLOW]}zshhelp tasks${colors[RESET]} - Display help for task management"
    echo -e "  ${colors[YELLOW]}zshhelp search${colors[RESET]} - Display help for search commands"
}

# Function to display help for Git commands
display_git_help() {
    echo -e "${colors[GREEN]}Git Commands and Aliases:${colors[RESET]}"
    echo -e "  ${colors[YELLOW]}g${colors[RESET]} - Shortcut for git"
    echo -e "  ${colors[YELLOW]}checkout${colors[RESET]} - Shortcut for git checkout"
    echo -e "  ${colors[YELLOW]}newbranch${colors[RESET]} - Shortcut for git checkout -b"
    echo -e "  ${colors[YELLOW]}push${colors[RESET]} - Shortcut for git push"
    echo -e "  ${colors[YELLOW]}pull${colors[RESET]} - Shortcut for git pull"
    echo -e "  ${colors[YELLOW]}status${colors[RESET]} - Shortcut for git status"
    echo -e "  ${colors[YELLOW]}commit${colors[RESET]} - Shortcut for git commit -m"
    echo -e "  ${colors[YELLOW]}add${colors[RESET]} - Shortcut for git add"
    echo -e "  ${colors[YELLOW]}pushf${colors[RESET]} - Shortcut for git push --force-with-lease"
    echo -e "  ${colors[YELLOW]}remote${colors[RESET]} - Shortcut for git remote -v"
    echo -e "  ${colors[YELLOW]}copyremote${colors[RESET]} - Copy git remote URL to clipboard"
    echo -e "  ${colors[YELLOW]}clone${colors[RESET]} - Shortcut for git clone"
    echo -e "  ${colors[YELLOW]}fetch${colors[RESET]} - Shortcut for git fetch"
    echo -e "  ${colors[YELLOW]}merge${colors[RESET]} - Shortcut for git merge"
    echo -e "  ${colors[YELLOW]}rebase${colors[RESET]} - Shortcut for git rebase"
    echo -e "  ${colors[YELLOW]}reset${colors[RESET]} - Shortcut for git reset"
    echo -e "  ${colors[YELLOW]}revert${colors[RESET]} - Shortcut for git revert"
    echo -e "  ${colors[YELLOW]}tag${colors[RESET]} - Shortcut for git tag"
    echo -e "  ${colors[YELLOW]}branch${colors[RESET]} - Shortcut for git branch"
    echo -e "  ${colors[YELLOW]}log${colors[RESET]} - Shortcut for git log"
}

# Function to display help for NVM commands
display_nvm_help() {
    echo -e "${colors[GREEN]}NVM Commands:${colors[RESET]}"
    echo -e "  ${colors[YELLOW]}nvm install${colors[RESET]} - Install a specific Node.js version"
    echo -e "  ${colors[YELLOW]}nvm use${colors[RESET]} - Use a specific Node.js version"
    echo -e "  ${colors[YELLOW]}nvm ls${colors[RESET]} - List installed Node.js versions"
    echo -e "  ${colors[YELLOW]}nvm ls-remote${colors[RESET]} - List available Node.js versions"
    echo -e "  ${colors[YELLOW]}nvm alias${colors[RESET]} - Create an alias for a Node.js version"
}

# Function to display help for custom aliases
display_aliases_help() {
    echo -e "${colors[GREEN]}Custom Aliases:${colors[RESET]}"
    echo -e "  ${colors[YELLOW]}xx${colors[RESET]} - Exit the terminal"
    echo -e "  ${colors[YELLOW]}cc${colors[RESET]} - Clear the terminal"
    echo -e "  ${colors[YELLOW]}ll${colors[RESET]} - List files with details"
    echo -e "  ${colors[YELLOW]}l${colors[RESET]} - List files"
    echo -e "  ${colors[YELLOW]}cat${colors[RESET]} - Display file contents with syntax highlighting"
    echo -e "  ${colors[YELLOW]}zsh${colors[RESET]} - Open .zshrc in vim"
    echo -e "  ${colors[YELLOW]}szsh${colors[RESET]} - Source .zshrc"
    echo -e "  ${colors[YELLOW]}czsh${colors[RESET]} - Open .zshrc in VS Code"
    echo -e "  ${colors[YELLOW]}cursor${colors[RESET]} - Open cursor IDE"
    echo -e "  ${colors[YELLOW]}createfile${colors[RESET]} - Create a new file with a shebang line"
}

# Function to display help for colorize output
display_colorize_help() {
    echo -e "${colors[GREEN]}Colorize Output:${colors[RESET]}"
    echo -e "  ${colors[YELLOW]}colorize${colors[RESET]} - Colorize the output of commands"
}

# Function to display help for task management
display_tasks_help() {
    echo -e "${colors[GREEN]}Task Management Commands:${colors[RESET]}"
    echo -e "  ${colors[YELLOW]}task 'task description' --by 'due time'${colors[RESET]} - Add a new task"
    echo -e "  ${colors[YELLOW]}task --list${colors[RESET]} - List all tasks"
    echo -e "  ${colors[YELLOW]}task remove <task_number>${colors[RESET]} - Remove a specific task"
    echo -e "  ${colors[YELLOW]}task remove-all${colors[RESET]} - Remove all tasks"
}

# Function to display help for search commands
display_search_help() {
    echo -e "${colors[GREEN]}Search Commands:${colors[RESET]}"
    echo -e "  ${colors[YELLOW]}search [OPTIONS] PATTERN${colors[RESET]} - Search for files or folders"
    echo -e "  ${colors[YELLOW]}--from DIR${colors[RESET]} - Start search from specified directory"
    echo -e "  ${colors[YELLOW]}--depth N${colors[RESET]} - Limit search depth to N levels"
    echo -e "  ${colors[YELLOW]}--ext EXT1,EXT2${colors[RESET]} - Specify file extensions to search"
    echo -e "  ${colors[YELLOW]}--folder${colors[RESET]} - Search for folders instead of files"
    echo -e "  ${colors[YELLOW]}--string${colors[RESET]} - Search inside files for the pattern"
    echo -e "  ${colors[YELLOW]}--max-size SIZE${colors[RESET]} - Limit results to files smaller than SIZE"
    echo -e "  ${colors[YELLOW]}--last-used${colors[RESET]} - Sort results by last used (modified) time"
}

# Main function to handle help menu display
zsh_help() {
    case $1 in
        git) display_git_help ;;
        nvm) display_nvm_help ;;
        aliases) display_aliases_help ;;
        colorize) display_colorize_help ;;
        tasks) display_tasks_help ;;
        search) display_search_help ;;
        *) display_help_menu ;;
    esac
}

# Aliases
alias zshhelp='zsh_help'
alias help='zsh_help'