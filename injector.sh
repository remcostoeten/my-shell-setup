#!/bin/bash

# Set the dotfiles path
export DOTFILES_PATH="${DOTFILES_PATH:-$HOME/.config/dotfiles}"

# Source the colors file first if it exists
if [ -f "$DOTFILES_PATH/initialize/colors.sh" ]; then
    source "$DOTFILES_PATH/initialize/colors.sh"
fi

# Function to log messages
log() {
    local level=$1
    shift
    local message=$*
    
    case "$level" in
        "info")
            echo -e "${BLUE}[INFO]${NC} $message"
            ;;
        "warn")
            echo -e "${YELLOW}[WARN]${NC} $message" >&2
            ;;
        "error")
            echo -e "${RED}[ERROR]${NC} $message" >&2
            ;;
    esac
}

# Create required directories if they don't exist
required_dirs=(
    "$DOTFILES_PATH/aliases"
    "$DOTFILES_PATH/initialize"
    "$DOTFILES_PATH/packages"
    "$DOTFILES_PATH/programs"
)

for dir in "${required_dirs[@]}"; do
    if [ ! -d "$dir" ]; then
        mkdir -p "$dir"
        log "info" "Created directory: $dir"
    fi
done

# Source all injectors
if [ -d "$DOTFILES_PATH/injectors" ]; then
    log "info" "Loading injectors from $DOTFILES_PATH/injectors"
    for injector in "$DOTFILES_PATH/injectors"/*; do
        if [ -f "$injector" ]; then
            log "info" "Sourcing injector: $(basename "$injector")"
            source "$injector"
        fi
    done
else
    log "error" "Injectors directory not found at $DOTFILES_PATH/injectors"
fi

# Create alias for reloading the configuration
alias reload-config="source $DOTFILES_PATH/injector.sh"
alias dotfiles="cd $DOTFILES_PATH" 