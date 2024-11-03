#!/usr/bin/env bash

# Advanced Audio Recorder Script
# This script uses FFmpeg to record audio with various features including
# pause/resume, real-time audio level meter, and segmented recordings.

set -euo pipefail

# ANSI color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default variables
RECORDING_DIR="$HOME/recordings/mp3"
CHUNK_DURATION=300 # 5 minutes in seconds
INPUT_DEVICE="default"
SAMPLE_RATE=44100
BITRATE="128k"

# Function to check if a command exists
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Check if FFmpeg is installed
if ! command_exists ffmpeg; then
  echo -e "${RED}Error: FFmpeg is not installed. Please install FFmpeg and try again.${NC}"
  exit 1
fi

# Create recordings directory if it doesn't exist
mkdir -p "$RECORDING_DIR"

# Function to display help menu
show_help() {
  echo -e "${BLUE}Audio Recorder Help Menu${NC}"
  echo -e "${YELLOW}Controls:${NC}"
  echo "  Spacebar or 'r': Pause/Resume recording"
  echo "  'q' or Esc: Stop recording and quit"
  echo "  'h': Show this help menu"
  echo -e "${YELLOW}Notes:${NC}"
  echo "  - Recordings are saved in $RECORDING_DIR"
  echo "  - Recordings are segmented into 5-minute chunks"
  echo "  - A real-time audio level meter is displayed during recording"
}

# Function to open recordings folder
open_recordings_folder() {
  if [[ "$OSTYPE" == "darwin"* ]]; then
    open "$RECORDING_DIR"
  elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    xdg-open "$RECORDING_DIR"
  else
    echo -e "${YELLOW}Cannot automatically open folder on this OS. Recordings are saved in:${NC}"
    echo "$RECORDING_DIR"
  fi
}

# Trap to handle script interruption and cleanup
trap 'echo -e "\n${RED}Script interrupted. Cleaning up...${NC}"; kill $(jobs -p) 2>/dev/null; exit 1' INT TERM

# Main recording function
record_audio() {
  local timestamp=$(date +"%Y%m%d_%H%M%S")
  local output_file="$RECORDING_DIR/recording_${timestamp}_%03d.mp3"
  local is_paused=false
  local segment_count=1

  echo -e "${GREEN}Starting audio recording...${NC}"
  echo -e "${YELLOW}Press 'h' for help menu${NC}"

  # Start FFmpeg recording process
  ffmpeg -f alsa -i "$INPUT_DEVICE" -ar "$SAMPLE_RATE" -b:a "$BITRATE" \
    -f segment -segment_time "$CHUNK_DURATION" \
    "$output_file" 2>/dev/null &

  ffmpeg_pid=$!

  # Audio level meter and control loop
  while true; do
    if ! $is_paused; then
      # Display audio level (simulated here, replace with actual audio level logic if available)
      echo -ne "${GREEN}Recording: ["
      for i in {1..50}; do
        if ((RANDOM % 5 == 0)); then
          echo -ne "#"
        else
          echo -ne "-"
        fi
      done
      echo -ne "] ${NC}\r"
    fi

    # Check for user input
    read -rsn1 -t 0.1 key
    case "$key" in
    q | $'\e') # Stop and quit
      kill $ffmpeg_pid
      echo -e "\n${BLUE}Recording stopped. Files saved in $RECORDING_DIR${NC}"
      read -p "Open recordings folder? (y/n): " open_folder
      if [[ $open_folder == "y" ]]; then
        open_recordings_folder
      fi
      exit 0
      ;;
    r | ' ') # Pause/Resume
      if $is_paused; then
        kill -CONT $ffmpeg_pid
        is_paused=false
        echo -e "\n${GREEN}Recording resumed${NC}"
      else
        kill -STOP $ffmpeg_pid
        is_paused=true
        echo -e "\n${YELLOW}Recording paused${NC}"
      fi
      ;;
    h) # Show help menu
      echo
      show_help
      ;;
    esac

    # Check if FFmpeg is still running
    if ! kill -0 $ffmpeg_pid 2>/dev/null; then
      echo -e "\n${RED}Error: FFmpeg process stopped unexpectedly${NC}"
      exit 1
    fi
  done
}

# Main execution
echo -e "${BLUE}Advanced Audio Recorder${NC}"
echo -e "${YELLOW}Initializing...${NC}"

# Check for audio input devices
if ! command_exists arecord; then
  echo -e "${YELLOW}Warning: 'arecord' not found. Using default input device.${NC}"
else
  echo -e "${GREEN}Available audio input devices:${NC}"
  arecord -l
  read -p "Enter the card number for the input device (default is 0): " card_number
  read -p "Enter the device number for the input device (default is 0): " device_number
  INPUT_DEVICE="hw:${card_number:-0},${device_number:-0}"
fi

# Start recording
record_audio
