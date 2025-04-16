#!/bin/bash

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DOTFILES_PATH="$(dirname "$SCRIPT_DIR")"

# Source colors first if available
if [ -f "$DOTFILES_PATH/initialize/colors.sh" ]; then
    source "$DOTFILES_PATH/initialize/colors.sh"
fi

# Function to display helper menu
function alias_helper() {
    echo -e "${GREEN}Alias Helper Menu${NC}"
    echo -e "-----------------"
    echo -e "1. List all aliases"
    echo -e "2. Create new alias file"
    echo -e "3. Help"
    echo -e "4. Exit"
    echo -e "-----------------"
}

# Function to create new alias file
function create_alias_file() {
    echo -e "${YELLOW}Creating new alias file${NC}"
    read -p "Enter the name of the new alias file (without .sh): " filename
    if [ -z "$filename" ]; then
        echo -e "${RED}Filename cannot be empty${NC}"
        return 1
    fi
    
    # Create the file with proper header and footer
    cat > "$DOTFILES_PATH/aliases/${filename}.sh" << EOF
#!/bin/bash
# File: ${filename}.sh
# Created: $(date +"%Y-%m-%d")
# Last Updated: $(date +"%Y-%m-%d")
# Description: Custom aliases for ${filename}

# Add your aliases here

# End of file
EOF
    
    echo -e "${GREEN}Created new alias file: ${filename}.sh${NC}"
    chmod +x "$DOTFILES_PATH/aliases/${filename}.sh"
}

# Main alias sourcing logic
if [ -d "$DOTFILES_PATH/aliases" ]; then
    for alias_file in "$DOTFILES_PATH"/aliases/*.sh; do
        if [ -f "$alias_file" ]; then
            source "$alias_file"
        fi
    done
fi

# Interactive menu
if [[ $- == *i* ]]; then
    while true; do
        alias_helper
        read -p "Enter your choice (1-4): " choice
        case $choice in
            1)
                echo -e "${BLUE}Available alias files:${NC}"
                ls -1 "$DOTFILES_PATH/aliases/"*.sh 2>/dev/null || echo "No alias files found"
                ;;
            2)
                create_alias_file
                ;;
            3)
                echo -e "${BLUE}Help:${NC}"
                echo "This injector manages your shell aliases."
                echo "You can create new alias files and they will be automatically sourced."
                echo "Place your alias files in the aliases/ directory with .sh extension."
                ;;
            4)
                break
                ;;
            *)
                echo -e "${RED}Invalid choice${NC}"
                ;;
        esac
    done
fi 