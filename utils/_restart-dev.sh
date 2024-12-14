#!/bin/bash

# Color definitions and utilities
declare -A colors=(
    ["INFO"]="%F{blue}"
    ["SUCCESS"]="%F{green}"
    ["WARNING"]="%F{yellow}"
    ["ERROR"]="%F{red}"
    ["RESET"]="%f"
)

# Helper functions
log_message() {
    local type=$1
    local emoji=$2
    local message=$3
    print -P "${colors[$type]}$emoji $message${colors[RESET]}"
}

check_package_json() {
    if [[ ! -f "package.json" ]]; then
        log_message "ERROR" "❌" "No package.json found. Are you in the right directory?"
        return 1
    fi
}

clean_directories() {
    local dirs=("node_modules" ".next")
    
    log_message "INFO" "🧹" "Cleaning project directories..."
    
    for dir in "${dirs[@]}"; do
        if [[ -d "$dir" ]]; then
            log_message "INFO" "📦" "Removing $dir..."
            rm -rf "$dir"
            log_message "SUCCESS" "✅" "$dir removed"
        fi
    done
}

install_dependencies() {
    log_message "WARNING" "📥" "Installing dependencies with pnpm..."
    if pnpm install; then
        log_message "SUCCESS" "✅" "Dependencies installed successfully"
        return 0
    else
        log_message "ERROR" "❌" "Failed to install dependencies"
        return 1
    fi
}

start_dev_server() {
    log_message "INFO" "🚀" "Starting Next.js development server with Turbo..."
    log_message "INFO" "⌛" "Please wait..."
    pnpm next dev --turbo
}

open_in_browser() {
    local port=$(grep -o '"dev":.*"next dev.*-p \([0-9]*\)' package.json | grep -o '[0-9]*' || echo "3000")
    log_message "INFO" "🌐" "Waiting for server on port $port..."
    
    # Wait for server to be ready
    while ! nc -z localhost $port; do
        sleep 1
    done
    
    log_message "SUCCESS" "🚀" "Opening http://localhost:$port in browser..."
    xdg-open "http://localhost:$port"
}

# Main functions
restart_dev() {
    check_package_json || return 1
    clean_directories
    install_dependencies || return 1
    start_dev_server
}

dev_mode() {
    check_package_json || return 1
    pnpm run dev &
    open_in_browser
}

# Aliases
alias restart='restart_dev'
alias dev='dev_mode'