#!/bin/bash

# Base directory
export BASE_DIR="$HOME/projects/zsh-setup"

# Load core utilities first
source "${BASE_DIR}/utils/utils_injector.sh"

# Load package management
source "${BASE_DIR}/packages/package-injector.sh"

# Load aliases
source "${BASE_DIR}/alias/alias_injector.sh"

# Load scripts
source "${BASE_DIR}/scripts/script_injector.sh"

source ./_welcome-message.sh
