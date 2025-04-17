#!/bin/bash

# File: dotfiles-architect.sh
# Created: $(date +%Y-%m-%d)
# Description: Dotfiles architecture management tool

# Prevent execution when being sourced
(return 0 2>/dev/null) && sourced=1 || sourced=0

# Source colors for pretty output
source "$DOTFILES_PATH/initialize/colors.sh"

# Constants
DOTFILES_ROOT="${DOTFILES_PATH:-$HOME/.config/dotfiles}"
REQUIRED_DIRS=("aliases" "programs" "scripts" "initialize" "injectors")

# Helper Functions
print_header() {
    echo -e "\n${BLUE}╔════════════════════════════════════════╗${RESET}"
    echo -e "${BLUE}║       Dotfiles Architect Tool v1.0      ║${RESET}"
    echo -e "${BLUE}╚════════════════════════════════════════╝${RESET}\n"
}

print_menu() {
    echo -e "${YELLOW}Available Commands:${RESET}"
    echo -e "  ${GREEN}1${RESET}. Validate Architecture"
    echo -e "  ${GREEN}2${RESET}. Create New Module"
    echo -e "  ${GREEN}3${RESET}. Create New Injector"
    echo -e "  ${GREEN}4${RESET}. Create New File"
    echo -e "  ${GREEN}5${RESET}. Run Pre-Push Checks"
    echo -e "  ${GREEN}h${RESET}. Show This Help Menu"
    echo -e "  ${GREEN}q${RESET}. Quit\n"
}

validate_architecture() {
    local has_errors=0
    echo -e "${CYAN}Validating dotfiles architecture...${RESET}\n"

    # Check required directories exist
    for dir in "${REQUIRED_DIRS[@]}"; do
        if [ ! -d "$DOTFILES_ROOT/$dir" ]; then
            echo -e "${RED}✗ Missing required directory: $dir${RESET}"
            has_errors=1
        else
            echo -e "${GREEN}✓ Found directory: $dir${RESET}"
        fi
    done

    # Check each directory has a corresponding injector
    for dir in "${REQUIRED_DIRS[@]}"; do
        if [ "$dir" != "injectors" ]; then
            if [ ! -f "$DOTFILES_ROOT/injectors/${dir}-injector" ]; then
                echo -e "${RED}✗ Missing injector for directory: $dir${RESET}"
                has_errors=1
            else
                echo -e "${GREEN}✓ Found injector for: $dir${RESET}"
            fi
        fi
    done

    return $has_errors
}

create_new_module() {
    echo -e "${CYAN}Creating new module...${RESET}"
    read -p "Enter module name: " module_name

    if [ -z "$module_name" ]; then
        echo -e "${RED}Module name cannot be empty${RESET}"
        return 1
    fi

    # Create directory
    mkdir -p "$DOTFILES_ROOT/$module_name"
    echo -e "${GREEN}✓ Created directory: $module_name${RESET}"

    # Create injector
    create_injector "$module_name"

    # Add to REQUIRED_DIRS
    echo -e "\n# Added by dotfiles-architect" >> "$DOTFILES_ROOT/initialize/config.sh"
    echo "REQUIRED_DIRS+=(\"$module_name\")" >> "$DOTFILES_ROOT/initialize/config.sh"

    echo -e "${GREEN}✓ Module $module_name created successfully${RESET}"
}

create_injector() {
    local module_name=$1
    [ -z "$module_name" ] && read -p "Enter module name for injector: " module_name

    if [ -z "$module_name" ]; then
        echo -e "${RED}Module name cannot be empty${RESET}"
        return 1
    fi

    local injector_path="$DOTFILES_ROOT/injectors/${module_name}-injector"
    
    cat > "$injector_path" << EOF
#!/bin/bash

# File: ${module_name}-injector
# Created: $(date +%Y-%m-%d)
# Description: Sources all files in the ${module_name} directory

if [ -d "\$DOTFILES_PATH/${module_name}" ]; then
    for file in "\$DOTFILES_PATH/${module_name}"/*; do
        if [ -f "\$file" ]; then
            source "\$file"
        fi
    done
    unset file
fi
EOF

    chmod +x "$injector_path"
    echo -e "${GREEN}✓ Created injector: ${module_name}-injector${RESET}"
}

create_new_file() {
    echo -e "${CYAN}Creating new file...${RESET}"
    
    # List available directories
    echo -e "\nAvailable directories:"
    local i=1
    for dir in "${REQUIRED_DIRS[@]}"; do
        echo -e "  ${GREEN}$i${RESET}. $dir"
        ((i++))
    done

    read -p "Select directory number: " dir_num
    local selected_dir="${REQUIRED_DIRS[$((dir_num-1))]}"

    if [ -z "$selected_dir" ]; then
        echo -e "${RED}Invalid directory selection${RESET}"
        return 1
    fi

    read -p "Enter file name (without .sh): " file_name
    local full_path="$DOTFILES_ROOT/$selected_dir/${file_name}.sh"

    cat > "$full_path" << EOF
#!/bin/bash

# File: ${file_name}.sh
# Created: $(date +%Y-%m-%d)
# Description: 
# TODO: Add description

EOF

    chmod +x "$full_path"
    echo -e "${GREEN}✓ Created file: ${file_name}.sh in $selected_dir${RESET}"
}

run_pre_push_checks() {
    echo -e "${CYAN}Running pre-push architecture validation...${RESET}"
    
    if ! validate_architecture; then
        echo -e "${RED}✗ Architecture validation failed${RESET}"
        echo -e "${YELLOW}Please fix the above issues before pushing${RESET}"
        return 1
    fi

    echo -e "${GREEN}✓ All architecture checks passed${RESET}"
    return 0
}

# Only run the main execution if script is being run directly (not sourced)
if [ "$sourced" = "0" ]; then
    if [ "$1" = "5" ]; then
        # Silent mode for pre-push checks
        validate_architecture
        exit $?
    elif [ -n "$1" ]; then
        # Execute specific command without menu
        case $1 in
            1) validate_architecture ;;
            2) create_new_module ;;
            3) create_injector ;;
            4) create_new_file ;;
            5) validate_architecture ;;
            *) echo -e "${RED}Invalid command: $1${RESET}" ;;
        esac
        exit $?
    else
        # Interactive mode
        while true; do
            print_header
            print_menu
            
            read -p "Enter command: " cmd
            
            case $cmd in
                1) validate_architecture ;;
                2) create_new_module ;;
                3) create_injector ;;
                4) create_new_file ;;
                5) validate_architecture ;;
                h) print_menu ;;
                q) exit 0 ;;
                *) echo -e "${RED}Invalid command${RESET}" ;;
            esac
            
            echo -e "\nPress any key to continue..."
            read -n 1
            clear
        done
    fi
fi 