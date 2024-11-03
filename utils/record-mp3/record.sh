#!/bin/bash

# Check if arecord is installed
if ! command -v arecord &>/dev/null; then
  echo "Error: arecord not found. Please install ALSA utils:"
  echo "sudo apt-get install alsa-utils"
  exit 1
fi

# Check if lame is installed for MP3 conversion
if ! command -v lame &>/dev/null; then
  echo "Error: lame not found. Please install lame:"
  echo "sudo apt-get install lame"
  exit 1
fi

# Generate timestamp for filename
TIMESTAMP=$(date '+%Y%m%d_%H%M%S')
OUTPUT_FILE="recording_${TIMESTAMP}.mp3"
TEMP_WAV="/tmp/recording_${TIMESTAMP}.wav"

# Initialize recording state
RECORDING=true
PAUSED=false
PID=""

# Function to start recording
start_recording() {
  arecord -f cd -t wav "$TEMP_WAV" &
  PID=$!
  echo "Recording... (Space to pause, Enter/Escape to stop)"
}

# Function to handle cleanup
cleanup() {
  if [ -n "$PID" ]; then
    kill $PID 2>/dev/null
  fi
  if [ -f "$TEMP_WAV" ]; then
    # Convert WAV to MP3
    lame "$TEMP_WAV" "$OUTPUT_FILE" 2>/dev/null
    rm "$TEMP_WAV"
    echo "Recording saved as: $OUTPUT_FILE"
  fi
  exit 0
}

# Set up cleanup on script exit
trap cleanup EXIT

# Function to handle keyboard input
handle_input() {
  while IFS= read -r -n1 key; do
    # Convert key to ASCII code
    key_ascii=$(printf "%d" "'$key")

    # Space key (32)
    if [ "$key_ascii" -eq 32 ]; then
      if [ "$PAUSED" = false ]; then
        kill -STOP $PID 2>/dev/null
        PAUSED=true
        echo "Recording paused. Press Space to resume."
      else
        kill -CONT $PID 2>/dev/null
        PAUSED=false
        echo "Recording resumed..."
      fi
    # Enter key (10) or Escape key (27)
    elif [ "$key_ascii" -eq 10 ] || [ "$key_ascii" -eq 27 ]; then
      echo "Stopping recording..."
      RECORDING=false
      break
    fi
  done
}

# Start initial recording
echo "Starting audio recording..."
echo "Controls:"
echo "  - Press Space to pause/resume"
echo "  - Press Enter or Escape to stop"
start_recording

# Start handling keyboard input
handle_input

# Wait for recording process to finish
wait $PID 2>/dev/null
