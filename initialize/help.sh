#!/bin/bash
# File: help.sh
# Created: $(date +"%Y-%m-%d")
# Description: Help system for dotfiles

function show_dotfiles_help() {
    echo -e "${BLUE}=== Dotfiles Help System ===${NC}\n"
    
    echo -e "${GREEN}Available Commands:${NC}"
    echo -e "  ${YELLOW}General:${NC}"
    echo -e "    reload-config     - Reload all dotfiles configurations"
    echo -e "    dotfiles         - Navigate to dotfiles directory"
    
    echo -e "\n  ${YELLOW}Alias Management:${NC}"
    echo -e "    manage-aliases   - Open alias manager interface"
    echo -e "    aliases-help     - Show alias help"
    echo -e "    aliases-h        - Show alias help (shorthand)"
    
    echo -e "\n  ${YELLOW}Package Management:${NC}"
    echo -e "    manage-packages  - Open package manager interface"
    
    echo -e "\n  ${YELLOW}Program Management:${NC}"
    echo -e "    manage-programs  - Open program manager interface"
    
    echo -e "\n  ${YELLOW}LS Commands (using eza):${NC}"
    echo -e "    l               - List files in long format"
    echo -e "    ll              - List all files in long format"
    echo -e "    lt              - Tree view (level 2)"
    echo -e "    la              - List all files"
    echo -e "    lg              - List with git status"
    echo -e "    lh              - List with header"
    echo -e "    ltree           - Full tree view"
    echo -e "    li              - List with icons"
    
    echo -e "\n${GREEN}Directory Structure:${NC}"
    echo -e "  ~/.config/dotfiles/"
    echo -e "  ├── aliases/      - Store all alias files"
    echo -e "  ├── initialize/   - Initialization scripts"
    echo -e "  ├── packages/     - Package configurations"
    echo -e "  ├── programs/     - Program configurations"
    echo -e "  └── injectors/    - Script injectors"
    
    echo -e "\n${GREEN}Quick Tips:${NC}"
    echo -e "1. Use 'reload-config' after making changes"
    echo -e "2. All managers have interactive menus"
    echo -e "3. Use 'manage-X' commands to access tools"
    echo -e "4. Check logs for troubleshooting\n"
}

# Create help aliases
alias dotfiles-help="show_dotfiles_help"
alias help="show_dotfiles_help"
alias h="show_dotfiles_help"

# Show help on first load if interactive shell
if [[ $- == *i* ]]; then
    show_dotfiles_help
fi 