#!/bin/bash

update_timestamp() {
    local TIMESTAMP=$(date "+%d %b %H:%M:%S")
    local CONFIG_FILE="${HOME}/projects/zsh-setup/initialize/_zsh-help-menu.sh"
    
    # Update timestamp in a more reliable way
    if [ -f "$CONFIG_FILE" ]; then
        sed -i "s/last updated:.*$/last updated: $TIMESTAMP/" "$CONFIG_FILE"
        return 0
    else
        echo "Config file not found: $CONFIG_FILE"
        return 1
    fi
}

get_current_time() {
    date "+%H:%M:%S"
}

get_uptime() {
    uptime -p | sed 's/up //'
} 
