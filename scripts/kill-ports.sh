#!/bin/bash

print_help() {
  echo "Usage: killport [OPTIONS]"
  echo
  echo "Interactive port killer utility that shows active ports in specified ranges"
  echo "and allows killing processes using arrow keys and spacebar."
  echo
  echo "Options:"
  echo "  --help, -h    Show this help message"
  echo
  echo "Port ranges checked:"
  echo "  3000-3020"
  echo "  5750-5799"
  echo "  8000-8010"
  echo "  8078-8098"
  echo
  echo "Navigation:"
  echo "  ↑/↓           Move selection"
  echo "  SPACE         Toggle selection"
  echo "  ENTER         Kill selected processes"
  echo "  q             Quit without killing"
}

if [[ "$1" == "--help" ]] || [[ "$1" == "-h" ]]; then
  print_help
  exit 0
fi

# Check if required commands exist
for cmd in lsof awk sed tput; do
  if ! command -v $cmd &>/dev/null; then
    echo "Error: Required command '$cmd' not found. Please install it first."
    exit 1
  fi
done

# Function to get active ports in specified ranges
get_active_ports() {
  local ports=$(lsof -i -P -n | grep LISTEN)
  local filtered_ports=$(echo "$ports" | awk '
        $9 ~ /:/ {
            split($9, a, ":")
            port = a[2]
            if ((port >= 3000 && port <= 3020) ||
                (port >= 5750 && port <= 5799) ||
                (port >= 8000 && port <= 8010) ||
                (port >= 8078 && port <= 8098)) {
                print $2 ":" port ":" $1
            }
        }
    ' | sort -t: -k2n | uniq)
  echo "$filtered_ports"
}

# Function to handle terminal UI
show_interactive_menu() {
  local ports=("$@")
  local num_ports=${#ports[@]}
  if [ $num_ports -eq 0 ]; then
    echo "No active ports found in specified ranges."
    exit 0
  fi

  local selected=()
  for ((i = 0; i < num_ports; i++)); do
    selected[$i]=0
  done

  local current=0
  local running=true

  # Hide cursor and restore on exit
  tput civis
  trap 'tput cnorm' EXIT

  while $running; do
    # Clear screen
    echo -en "\033[2J\033[H"
    echo "Active Ports (use ↑↓ to move, SPACE to select, ENTER to kill, q to quit):"
    echo

    # Display ports
    for ((i = 0; i < num_ports; i++)); do
      local port_info=(${ports[$i]//:/ })
      if [ $i -eq $current ]; then
        echo -en "\033[7m" # Reverse video
      fi
      if [ ${selected[$i]} -eq 1 ]; then
        echo -n "[X] "
      else
        echo -n "[ ] "
      fi
      echo -n "PID: ${port_info[0]} Port: ${port_info[1]} Process: ${port_info[2]}"
      if [ $i -eq $current ]; then
        echo -en "\033[0m"
      fi
      echo
    done

    # Read keypresses
    read -rsn1 key
    if [[ $key = q ]]; then
      running=false
    elif [[ $key = "" ]]; then # Enter key
      break
    elif [[ $key = " " ]]; then
      selected[$current]=$((1 - ${selected[$current]}))
    elif [[ $key = $'\x1b' ]]; then
      read -rsn2 key
      if [[ $key = "[A" ]] && [ $current -gt 0 ]; then # Up arrow
        ((current--))
      elif [[ $key = "[B" ]] && [ $current -lt $((num_ports - 1)) ]]; then # Down arrow
      elif [[ $key = "[B" ]] && [ $current -lt $((num_ports - 1)) ]; then # Down arrow
        ((current++))
      fi
    fi
  done

  # Kill selected processes
  local kill_count=0
  for ((i = 0; i < num_ports; i++)); do
    if [ ${selected[$i]} -eq 1 ]; then
      local pid=$(echo ${ports[$i]} | cut -d: -f1)
      if kill $pid 2>/dev/null; then
        ((kill_count++))
      fi
    fi
  done

  if [ $kill_count -gt 0 ]; then
    echo "Killed $kill_count process(es)"
  elif [ $running = false ]; then
    echo "Operation cancelled"
  else
    echo "No processes selected"
  fi
}

# Main execution
ports=($(get_active_ports))
show_interactive_menu "${ports[@]}"
show_interactive_menu "${ports[@]}"