#!/bin/zsh

# Main injector script
# Sources all individual injectors

SCRIPT_DIR="${0:A:h}"

# Load configuration
source "$SCRIPT_DIR/initialize/config.sh"

# Helper function for logging
log() {
    if [[ "$SHELL_VERBOSE" == "true" ]]; then
        echo "$@"
    fi
}

# Welcome message (if enabled)
if [[ "$SHELL_SHOW_WELCOME" == "true" ]]; then
    log "Initializing dotfiles from: $SCRIPT_DIR"
fi

# Source all injectors in order
for injector in "$SCRIPT_DIR/injectors"/*-injector; do
    if [ -f "$injector" ]; then
        log "Loading injector: $(basename "$injector")"
        source "$injector" 2>/dev/null
    fi
done

# Clear any error messages from the screen if not in verbose mode
if [[ "$SHELL_VERBOSE" != "true" ]]; then
    clear
fi 