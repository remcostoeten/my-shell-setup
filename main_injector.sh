#!/bin/bash

BASE_DIR="/home/remcostoeten/projects/zsh-setup"

# Source injector files
source "${BASE_DIR}/alias/alias_injector.sh"
source "${BASE_DIR}/packages/package-injector.sh"
source "${BASE_DIR}/utils/utils_injector.sh"

source "${BASE_DIR}/scripts/script_injector.sh"
source "${BASE_DIR}/core-settings/core_injector.sh"
source "${BASE_DIR}/initialize/_zsh-help-menu.sh"

source "${BASE_DIR}/_welcome-message.sh"

