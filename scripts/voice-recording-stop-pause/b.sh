#!/bin/bash

# Clear screen and hide cursor
clear
tput civis

# Trap to restore cursor on exit
trap 'tput cnorm; exit' INT TERM

# Initialize variables
is_paused=false
seconds=0
recording_pid=""

# Function to get timestamp for file
get_timestamp() {
  date +"%Y%m%d_%H%M%S"
}

# Function to display time in HH:MM:SS format
show_timer() {
  local seconds=$1
  printf "\033[2K\033[H\033[?25l" # Clear line and move to top
  printf "\e[1;36m"               # Cyan color, bold
  printf "╔══════════════════════════════╗\n"
  printf "║     Recording Time: %02d:%02d:%02d     ║\n" $((seconds / 3600)) $((seconds % 3600 / 60)) $((seconds % 60))
  printf "╚══════════════════════════════╝\n\n"
  if $is_paused; then
    printf "\e[1;33m⏸  PAUSED\e[0m\n" # Yellow color
  else
    printf "\e[1;31m⏺  RECORDING\e[0m\n" # Red color
  fi
  printf "\n[Space] to pause/resume, [Enter] to stop\n"
}

# Set up signal handling for pause/resume
pause_recording() {
  if ! $is_paused; then
    is_paused=true
    kill -SIGSTOP $(pgrep ffmpeg) 2>/dev/null
  else
    is_paused=false
    kill -SIGCONT $(pgrep ffmpeg) 2>/dev/null
  fi
}

# Function to handle keyboard input without blocking
read_key() {
  stty -echo
  stty raw
  dd bs=1 count=1 2>/dev/null
  stty -raw
  stty echo
}

# Main recording loop
stty -echo # Disable keyboard echo
while true; do
  show_timer $seconds

  if read -t 0.1 -N 1 key; then
    case "$key" in
    " ") # Space key
      pause_recording
      ;;
    $'\n') # Enter key
      break
      ;;
    esac
  fi

  if ! $is_paused; then
    ((seconds++))
  fi
  sleep 1
done

# Cleanup
stty echo  # Restore keyboard echo
tput cnorm # Show cursor
echo -e "\nRecording stopped"
exit 0
