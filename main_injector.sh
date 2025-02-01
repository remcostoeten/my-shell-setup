export BASE_DIR="$HOME/projects/zsh-setup"

# Array to store error messages
errors=()

# Function to source a file if it exists
source_if_exists() {
    if [ -f "$1" ]; then
        source "$1"
    else
        errors+=("File not found: $1")
    fi
}

# Load core utilities first
source_if_exists "${BASE_DIR}/utils/utils_injector.sh"

# Load package management
source_if_exists "${BASE_DIR}/packages/package-injector.sh"

# Load aliases
source_if_exists "${BASE_DIR}/alias/alias_injector.sh"

# Load scripts
source_if_exists "${BASE_DIR}/scripts/script_injector.sh"

# Load welcome message
source_if_exists ~/projects/zsh-setup/_welcome-message.sh

# Function to display errors
zsh_error() {
    if [ ${#errors[@]} -eq 0 ]; then
        echo "No errors found."
    else
        echo "The following errors occurred:"
        for error in "${errors[@]}"
        do
            echo "- $error"
        done
    fi
}

# Add zsh_error function to shell
if [ -z "$(type -t zsh_error)" ] || [ "$(type -t zsh_error)" != "function" ]; then
    echo 'zsh_error() {
        if [ ${#errors[@]} -eq 0 ]; then
            echo "No errors found."
        else
            echo "The following errors occurred:"
            for error in "${errors[@]}"
            do
                echo "- $error"
            done
        fi
    }' >> ~/.zshrc
fi

# Execute zsh_error to show any errors that occurred during setup
zsh_error

