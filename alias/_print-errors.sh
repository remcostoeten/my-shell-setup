#!/bin/bash

handle_error() {
    local exit_code=$1
    local error_message=$2
    echo -e "${COLOR_BOLD}${COLOR_RED}Error:${COLOR_RESET} ${error_message}" >&2
    exit $exit_code
}
