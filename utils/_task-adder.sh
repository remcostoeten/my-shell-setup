#!/bin/bash

TASKS_FILE="/home/remcostoeten/projects/zsh-setup/tasks.txt"

# Function to add a task
add_task() {
  local task="$1"
  local due_time="$2"
  echo "$task|$due_time" >>"$TASKS_FILE"
  echo "Task added: $task (Due: $due_time)"
}

# Function to list tasks
list_tasks() {
  if [[ ! -s "$TASKS_FILE" ]]; then
    echo "No tasks found."
    return
  fi

  echo "Current tasks:"
  local index=1
  while IFS='|' read -r task due_time; do
    echo "$index. $task (Due: $due_time)"
    ((index++))
  done <"$TASKS_FILE"
}

# Function to remove a task
remove_task() {
  local line_number=$1
  if [[ ! -s "$TASKS_FILE" ]]; then
    echo "No tasks to remove."
    return
  fi

  sed -i "${line_number}d" "$TASKS_FILE"
  echo "Task $line_number removed."
}

# Function to remove all tasks
remove_all_tasks() {
  >"$TASKS_FILE"
  echo "All tasks removed."
}

# Main function to handle task operations
task() {
  case "$1" in
  --list)
    list_tasks
    ;;
  remove)
    remove_task "$2"
    ;;
  remove-all)
    remove_all_tasks
    ;;
  *)
    local task="$1"
    local due_time="$3"
    if [[ "$2" == "--by" && -n "$due_time" ]]; then
      add_task "$task" "$due_time"
    else
      echo "Usage: task 'task description' --by 'due time'"
      echo "       task --list"
      echo "       task remove <task_number>"
      echo "       task remove-all"
    fi
    ;;
  esac
}

# Function to check and display tasks on CLI load
check_tasks() {
  if [[ ! -s "$TASKS_FILE" ]]; then
    return
  fi

  local task_count=$(wc -l <"$TASKS_FILE")
  local overdue_count=0

  while IFS='|' read -r task due_time; do
    if [[ -n "$due_time" ]]; then
      local current_time=$(date +%s)
      local due_time_epoch=$(date -d "$due_time" +%s)
      local time_diff=$((due_time_epoch - current_time))

      if [[ $time_diff -le 0 ]]; then
        ((overdue_count++))
      fi
    fi
  done <"$TASKS_FILE"

  if [[ $overdue_count -gt 0 ]]; then
  else
    echo "You have $task_count task(s) to do."
    local first_task=$(head -n 1 "$TASKS_FILE" | cut -d'|' -f1)
    local first_due_time=$(head -n 1 "$TASKS_FILE" | cut -d'|' -f2)
    echo "Next task: $first_task"

    if [[ -n "$first_due_time" ]]; then
      local current_time=$(date +%s)
      local due_time=$(date -d "$first_due_time" +%s)
      local time_diff=$((due_time - current_time))

      if [[ $time_diff -gt 0 ]]; then
        local minutes=$((time_diff / 60))
        echo "You have $minutes minutes to finish."
      else
        echo "This task is overdue!"
      fi
    fi
  fi
}

task --list
# Call check_tasks when the script is sourced
#check_tasks
