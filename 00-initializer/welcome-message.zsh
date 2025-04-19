#!/bin/zsh

# Version information
DOTFILES_VERSION="v1.0.3"
LAST_UPDATED=$(date "+%Y-%m-%d %H:%M:%S")

# Define colors (zsh format)
BLUE="%F{blue}"
GREEN="%F{green}"
YELLOW="%F{yellow}"
MAGENTA="%F{magenta}"
CYAN="%F{cyan}"
BOLD="%B"
NC="%f%b" # Reset colors and formatting

# Get terminal width for centering
TERM_WIDTH=$(tput cols)

# Function to center text
center_text() {
    local text="$1"
    local clean_text="${text//\%[fbBF\{\}]*\}/}" # Strip zsh color codes for width calculation
    local text_length=${#clean_text}
    local padding=$(( (TERM_WIDTH - text_length) / 2 ))
    print -P "%${padding}s$text"
}

# Only show welcome message if not in quiet mode
if [[ -z $DOTFILES_QUIET ]]; then
    print
    center_text "${MAGENTA}╔════════════════════════════════════╗${NC}"
    center_text "${MAGENTA}║${NC} ${CYAN}${BOLD}⚡ RemcoStoeten's Shell Config ⚡${NC} ${MAGENTA}║${NC}"
    center_text "${MAGENTA}╚════════════════════════════════════╝${NC}"
    print
    center_text "${BLUE}🕒 Last updated:${NC} ${GREEN}${LAST_UPDATED}${NC}"
    center_text "${YELLOW}🧪 Version:${NC} ${CYAN}${DOTFILES_VERSION}${NC}"
    print
fi 