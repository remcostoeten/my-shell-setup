#!/bin/bash
print_overdue_tasks() {
    local title="Overdue Tasks"
    local tasks_file="/home/remcostoeten/projects/zsh-setup/tasks.txt"
    local overdue_tasks=()

    while IFS='|' read -r task_title due_time; do
        local current_time=$(date +%s)
        local due_time_epoch=$(date -d "$due_time" +%s 2>/dev/null)
        
        if [[ $? -eq 0 && $due_time_epoch -lt $current_time ]]; then
            overdue_tasks+=("$task_title")
        fi
    done < "$tasks_file"

    if [[ ${#overdue_tasks[@]} -gt 0 ]]; then
        echo -e "${COLOR_BOLD}${COLOR_ORANGE}${title}:${COLOR_RESET}"
        for task in "${overdue_tasks[@]}"; do
            echo -e "${COLOR_BOLD}${COLOR_ORANGE}- ${task}${COLOR_RESET}"
        done
    fi
}
