# Shell Configuration
# Global settings for shell behavior

# Verbosity settings
export SHELL_VERBOSE=false      # Set to true to see detailed loading messages
export SHELL_SHOW_WELCOME=true  # Set to false to disable welcome message
export SHELL_SHOW_DOCKER=false  # Set to true to show Docker tool messages

# Load version information
if [ -f "$SCRIPT_DIR/version.txt" ]; then
    source "$SCRIPT_DIR/version.txt"
fi

# Suppress certain common messages
if [[ "$SHELL_VERBOSE" != "true" ]]; then
    # Redirect common noise to /dev/null
    zstyle ':completion:*' verbose false
    zstyle ':completion:*' silent true
fi 