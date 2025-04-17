#!/bin/bash

# =============================================================================
#   File: lock-shutdown-reboot.sh
#   Description: System control functions for locking, shutdown and reboot
#   Created: $(date +%Y-%m-%d)
#   Author: remcostoeten
# =============================================================================

# Source colors if available
if [ -f "$HOME/.config/dotfiles/initialize/colors.sh" ]; then
    source "$HOME/.config/dotfiles/initialize/colors.sh"
else
    # Fallback colors if colors.sh is not available
    GREEN='\033[0;32m'
    RED='\033[0;31m'
    YELLOW='\033[1;33m'
    BLUE='\033[0;34m'
    NC='\033[0m' # No Color
fi

# Function to handle system lock
lock() {
    echo -e "${BLUE}🔒 Locking system...${NC}"
    if [[ "$(uname)" == "Darwin" ]]; then
        pmset displaysleepnow
    else
        if command -v i3lock >/dev/null 2>&1; then
            i3lock -c 000000
        elif command -v gnome-screensaver-command >/dev/null 2>&1; then
            gnome-screensaver-command -l
        else
            echo -e "${RED}❌ No supported screen locker found${NC}"
            return 1
        fi
    fi
    echo -e "${GREEN}✅ System locked${NC}"
}

# Function to handle shutdown with optional delay
shutdown() {
    local delay=0
    
    # Parse arguments
    while [[ "$#" -gt 0 ]]; do
        case $1 in
            --d|--delay)
                delay="$2"
                shift 2
                ;;
            *)
                echo -e "${RED}❌ Unknown parameter: $1${NC}"
                return 1
                ;;
        esac
    done

    if [[ $delay -gt 0 ]]; then
        echo -e "${YELLOW}⏰ System will shutdown in ${delay} seconds...${NC}"
        sleep "$delay"
    fi

    echo -e "${RED}🔌 Shutting down system...${NC}"
    if [[ "$(uname)" == "Darwin" ]]; then
        sudo shutdown -h now
    else
        sudo shutdown -h now
    fi
}

# Function to handle reboot with optional delay
reboot() {
    local delay=0
    
    # Parse arguments
    while [[ "$#" -gt 0 ]]; do
        case $1 in
            --d|--delay)
                delay="$2"
                shift 2
                ;;
            *)
                echo -e "${RED}❌ Unknown parameter: $1${NC}"
                return 1
                ;;
        esac
    done

    if [[ $delay -gt 0 ]]; then
        echo -e "${YELLOW}⏰ System will reboot in ${delay} seconds...${NC}"
        sleep "$delay"
    fi

    echo -e "${YELLOW}🔄 Rebooting system...${NC}"
    if [[ "$(uname)" == "Darwin" ]]; then
        sudo reboot
    else
        sudo reboot
    fi
}

# Help function
show_help() {
    echo -e "${BLUE}System Control Commands Help${NC}"
    echo -e "${GREEN}Available commands:${NC}"
    echo -e "  ${YELLOW}lock${NC}                    - Lock the system screen"
    echo -e "  ${YELLOW}shutdown [--d seconds]${NC}  - Shutdown the system with optional delay"
    echo -e "  ${YELLOW}reboot [--d seconds]${NC}    - Reboot the system with optional delay"
    echo
    echo -e "${GREEN}Options:${NC}"
    echo -e "  ${YELLOW}--d, --delay${NC}           - Specify delay in seconds before shutdown/reboot"
    echo
    echo -e "${GREEN}Examples:${NC}"
    echo -e "  ${BLUE}lock${NC}"
    echo -e "  ${BLUE}shutdown --d 30${NC}"
    echo -e "  ${BLUE}reboot --d 10${NC}"
}

# Make the script executable
chmod +x "$0" 