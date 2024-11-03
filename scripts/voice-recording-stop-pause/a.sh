#!/bin/bash
# Made by Remco Stoeten (https://github.com/remcostoeten)

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
ORANGE='\033[38;5;208m'
NC='\033[0m'
BOLD='\033[1m'
DIM='\033[2m'

# Base directory structure
BASE_DIR="$HOME/projects/recorder"
AUDIO_DIR="$BASE_DIR/audio-files"
TRANSCRIPT_DIR="$BASE_DIR/transcriptions"
PROMPT_DIR="$BASE_DIR/prompts"

# Create directories if they don't exist
mkdir -p "$AUDIO_DIR" "$TRANSCRIPT_DIR" "$PROMPT_DIR"

# Configuration files
PID_FILE="/tmp/recorder_pid"
STATUS_FILE="/tmp/recorder_status"
COUNTER_FILE="/tmp/recorder_counter"
DURATION_FILE="/tmp/recorder_duration"
WHISPER_LOG="/tmp/whisper_progress"

show_help() {
    cat << EOF

${CYAN}██████╗ ███████╗ ██████╗ ██████╗ ██████╗ ██████╗ ███████╗██████╗
${CYAN}██╔══██╗██╔════╝██╔════╝██╔═══██╗██╔══██╗██╔══██╗██╔════╝██╔══██╗
${CYAN}██████╔╝█████╗  ██║     ██║   ██║██████╔╝██║  ██║█████╗  ██████╔╝
${CYAN}██╔══██╗██╔══╝  ██║     ██║   ██║██╔══██╗██║  ██║██╔══╝  ██╔══██╗
${CYAN}██║  ██║███████╗╚██████╗╚██████╔╝██║  ██║██████╔╝███████╗██║  ██║
${CYAN}╚═╝  ╚═╝╚══════╝ ╚═════╝ ╚═════╝ ╚═╝  ╚═╝╚═════╝ ╚══════╝╚═╝  ╚═╝${NC}

${BOLD}${GREEN}🎙️  Record, transcribe, and process audio with ease${NC}
${DIM}Made by Remco Stoeten (https://github.com/remcostoeten)${NC}

${BOLD}${BLUE}┌─ Usage ───────────────────────────────────────────────┐${NC}
${BLUE}│${NC} ./rec.sh [options]                                   ${BLUE}│${NC}
${BOLD}${BLUE}└────────────────────────────────────────────────────────┘${NC}

${BOLD}${ORANGE}🛠️  Options:${NC}
  ${YELLOW}-h, --help${NC}     Show this fancy help message
  ${YELLOW}--name${NC}         Custom name for your recording
                 ${DIM}Example: --name "team-meeting"
                 Creates: team-meeting-DD-MM-HH-MM.wav${NC}

  ${YELLOW}--prompt${NC}       Process transcript with AI
                 ${DIM}Example: --prompt "Summarize the key points"
                 Creates an additional prompt output file${NC}

  ${YELLOW}--open${NC}         Open the save directory after recording

${BOLD}${ORANGE}🔥 Examples:${NC}
  ${GREEN}1. Quick Recording:${NC}
     ${CYAN}./rec.sh${NC}
     ${DIM}Creates: DD-MM-HH-MM.wav${NC}

  ${GREEN}2. Named Recording:${NC}
     ${CYAN}./rec.sh --name "meeting-with-john"${NC}
     ${DIM}Creates: meeting-with-john-DD-MM-HH-MM.wav${NC}

  ${GREEN}3. AI Processing:${NC}
     ${CYAN}./rec.sh --name "interview" --prompt "Extract action items"${NC}
     ${DIM}Creates:
     ├── interview-DD-MM-HH-MM.wav
     ├── interview-DD-MM-HH-MM-recording.txt
     └── interview-DD-MM-HH-MM-prompt.txt${NC}

${BOLD}${ORANGE}⌨️  Controls:${NC}
  ${PURPLE}┌────────────┬────────────────────────┐${NC}
  ${PURPLE}│${NC} SPACE      ${PURPLE}│${NC} Pause/Resume recording  ${PURPLE}│${NC}
  ${PURPLE}│${NC} ENTER      ${PURPLE}│${NC} Stop recording/process  ${PURPLE}│${NC}
  ${PURPLE}│${NC} CTRL+C     ${PURPLE}│${NC} Cancel recording        ${PURPLE}│${NC}
  ${PURPLE}└────────────┴────────────────────────┘${NC}

${BOLD}${ORANGE}📁 Output Locations:${NC}
  ${PURPLE}Audio${NC}       → ~/projects/recorder/audio-files/
  ${PURPLE}Transcripts${NC} → ~/projects/recorder/transcriptions/
  ${PURPLE}AI Output${NC}   → ~/projects/recorder/prompts/

${DIM}For more information: https://github.com/remcostoeten/recorder${NC}

EOF
}

# Progress UI helpers
progress_bar() {
    local current=$1
    local total=$2
    local width=50
    local percentage=$((current * 100 / total))
    local completed=$((width * current / total))
    local remaining=$((width - completed))

    printf "\r${BLUE}["
    printf "%${completed}s" | tr ' ' '█'
    printf "%${remaining}s" | tr ' ' '░'
    printf "]${NC} ${YELLOW}%3d%%${NC}" $percentage
}

show_spinner() {
    local pid=$1
    local delay=0.1
    local spinstr='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'
    while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
        local temp=${spinstr#?}
        printf "\r${CYAN}[%c]${NC} " "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
    done
    printf "\r   \r"
}

format_time() {
    local total_seconds=$1
    local hours=$((total_seconds / 3600))
    local minutes=$(((total_seconds % 3600) / 60))
    local seconds=$((total_seconds % 60))
    printf "%02d:%02d:%02d" $hours $minutes $seconds
}

update_counter() {
    local current_time
    while [ -f "$COUNTER_FILE" ]; do
        if [ "$(cat "$STATUS_FILE")" = "running" ]; then
            current_time=$(($(cat "$DURATION_FILE")))
            current_time=$((current_time + 1))
            echo "$current_time" > "$DURATION_FILE"
            echo -en "\r\033[K"
            echo -en "\r${BOLD}${GREEN}Status:${NC} ⏺ ${BOLD}RECORDING${NC} | ${YELLOW}Duration: $(format_time $current_time)${NC} | Press ${CYAN}[SPACE]${NC} to pause, ${CYAN}[ENTER]${NC} to stop"
        else
            echo -en "\r\033[K"
            echo -en "\r${BOLD}${YELLOW}Status:${NC} ⏸ ${BOLD}PAUSED${NC} | ${YELLOW}Duration: $(format_time $(cat "$DURATION_FILE"))${NC} | Press ${CYAN}[SPACE]${NC} to resume, ${CYAN}[ENTER]${NC} to stop"
        fi
        sleep 1
    done
}

start_recording() {
    echo -e "${BOLD}${GREEN}Starting recording to:${NC} $OUTPUT_FILE"
    ffmpeg -f alsa -i default \
           -acodec pcm_s16le \
           -ac 1 \
           -ar 16000 \
           "$OUTPUT_FILE" \
           2>/dev/null &

    local rec_pid=$!
    echo "$rec_pid" > "$PID_FILE"
    echo "running" > "$STATUS_FILE"
    echo -e "\n\n${BOLD}${GREEN}Recording started. Controls:${NC}"
    echo -e "${CYAN}SPACE${NC} - pause/resume"
    echo -e "${CYAN}ENTER${NC} - stop and quit"
    echo -e "\n"

    update_counter &
    echo $! >> "$PID_FILE"
}

toggle_pause() {
    if [ "$(cat "$STATUS_FILE")" = "running" ]; then
        kill -STOP $(head -n 1 "$PID_FILE")
        echo "paused" > "$STATUS_FILE"
    else
        kill -CONT $(head -n 1 "$PID_FILE")
        echo "running" > "$STATUS_FILE"
    fi
}

process_with_llm() {
    local transcript="$1"
    local prompt="$2"
    local output_file="$3"
    local audio_file="$4"

    local transcript_content
    transcript_content=$(cat "$transcript")

    {
        echo "## Transcription from $(realpath --relative-to="$HOME" "$audio_file")"
        echo "*$(date '+%Y-%m-%d %H:%M')*"
        echo ""
        echo "$transcript_content"
        echo ""
        echo "_______________________________________________"
        echo ""
        echo "Enhanced with --prompt argument '$prompt' resulting in:"
        echo ""

        if command -v ollama >/dev/null 2>&1; then
            echo -e "Given this transcript:\n\n$transcript_content\n\n$prompt" | ollama run mistral
        else
            echo -e "${RED}Error: ollama not found. Please install it or modify the script to use your preferred LLM.${NC}"
            return 1
        fi
    } > "$output_file"

    echo -e "${GREEN}LLM processing completed. Output saved to: $output_file${NC}"
}

transcribe_audio() {
    clear
    echo -e "\n${BOLD}${BLUE}╔══════════════════════════════════════╗${NC}"
    echo -e "${BOLD}${BLUE}║         Audio Transcription          ║${NC}"
    echo -e "${BOLD}${BLUE}╚══════════════════════════════════════╝${NC}\n"

    echo -e "${YELLOW}⚡ Initializing transcription...${NC}"

    MODEL_PATH="$HOME/whisper.cpp/models/ggml-base.bin"
    if [ ! -f "$MODEL_PATH" ]; then
        MODEL_PATH="$HOME/whisper.cpp/models/ggml-base.en.bin"
    fi

    if [ -f "$MODEL_PATH" ]; then
        echo -e "${GREEN}✓${NC} Model loaded: $(basename "$MODEL_PATH")\n"

        echo -e "${BOLD}Processing:${NC} $(basename "$OUTPUT_FILE")"
        echo -e "${DIM}This may take a while depending on the file size...${NC}\n"

        whisper-cpp --model "$MODEL_PATH" \
                    --output-txt \
                    --threads 4 \
                    "$OUTPUT_FILE" > "$WHISPER_LOG" 2>&1 &

        local whisper_pid=$!
        show_spinner $whisper_pid

        if [ -f "${OUTPUT_FILE}.txt" ]; then
            mv "${OUTPUT_FILE}.txt" "$TRANSCRIPT_FILE"
            echo -e "\n\n${GREEN}✓ Transcription completed successfully!${NC}\n"
            echo -e "${BOLD}Files created:${NC}"
            echo -e "  ${BLUE}├─${NC} Audio: $(basename "$OUTPUT_FILE")"
            echo -e "  ${BLUE}└─${NC} Text:  $(basename "$TRANSCRIPT_FILE")"

            echo -e "\n${BOLD}Preview:${NC}"
            echo -e "${BLUE}────────────────────────────────${NC}"
            head -n 5 "$TRANSCRIPT_FILE"
            echo -e "${BLUE}────────────────────────────────${NC}"

            if [ -n "$PROMPT" ]; then
                echo -e "\n${PURPLE}🤖 Processing with AI...${NC}"
                process_with_llm "$TRANSCRIPT_FILE" "$PROMPT" "$PROMPT_FILE" "$OUTPUT_FILE"
            fi
        else
            echo -e "\n${RED}✗ Error: Transcription failed${NC}"
            echo -e "${DIM}Check the error log: $WHISPER_LOG${NC}"
        fi
    else
        echo -e "\n${RED}✗ Error: Whisper model not found${NC}"
        echo -e "Please download it:"
        echo -e "${BLUE}cd ~/whisper.cpp"
        echo -e "bash ./models/download-ggml-model.sh base${NC}"
        exit 1
    fi
}

cleanup() {
    if [ -f "$PID_FILE" ]; then
        while read -r pid; do
            kill -9 "$pid" 2>/dev/null
        done < "$PID_FILE"
    fi

    rm -f "$PID_FILE" "$STATUS_FILE" "$COUNTER_FILE" "$DURATION_FILE" "$WHISPER_LOG"
    stty "$saved_stty"

    echo -e "\n\n${GREEN}Recording stopped.${NC}"
    if [ -f "$OUTPUT_FILE" ]; then
        transcribe_audio
    fi
}

# Initialize variables
PROMPT=""
NAME=""
OPEN_DIR=false

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            show_help
            exit 0
            ;;
        --name)
            if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
                NAME=$2
                shift 2
            else
                echo -e "${RED}Error: --name requires a value${NC}" >&2
                exit 1
            fi
            ;;
        --prompt)
            if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
                PROMPT=$2
                shift 2
            else
                echo -e "${RED}Error: --prompt requires a value${NC}" >&2
                exit 1
            fi
            ;;
        --open)
            OPEN_DIR=true
            shift
            ;;
        *)
            echo -e "${RED}Error: Unknown option: $1${NC}" >&2
            show_help
            exit 1
            ;;
    esac
done

# Generate timestamp and filenames
timestamp=$(date "+%d-%m-%H-%M")
if [ -n "$NAME" ]; then
    NAME=$(echo "$NAME" | tr ' ' '_')
    OUTPUT_FILE="$AUDIO_DIR/${NAME}-${timestamp}.wav"
    TRANSCRIPT_FILE="$TRANSCRIPT_DIR/${NAME}-${timestamp}-recording.txt"

    PROMPT_FILE="$PROMPT_DIR/${NAME}-${timestamp}-prompt.txt"
    else
        OUTPUT_FILE="$AUDIO_DIR/$timestamp.wav"
        TRANSCRIPT_FILE="$TRANSCRIPT_DIR/${timestamp}-recording.txt"
        PROMPT_FILE="$PROMPT_DIR/${timestamp}-prompt.txt"
    fi

    # Check dependencies
    if ! command -v ffmpeg >/dev/null 2>&1; then
        echo -e "${RED}Error: ffmpeg not found. Please install it:${NC}"
        echo "sudo apt install ffmpeg  # For Debian/Ubuntu"
        exit 1
    fi

    if ! command -v whisper-cpp >/dev/null 2>&1; then
        echo -e "${RED}Error: whisper-cpp not found. Please install it:${NC}"
        echo "git clone https://github.com/ggerganov/whisper.cpp.git"
        echo "cd whisper.cpp"
        echo "make"
        echo "sudo make install"
        exit 1
    fi

    # Save terminal settings
    saved_stty=$(stty -g)

    # Configure terminal for immediate key detection
    stty raw isig -echo

    # Set up trap for cleanup
    trap 'cleanup' EXIT INT TERM

    # Clear screen and show initial info
    clear
    echo -e "${BOLD}${BLUE}╔══════════════════════════════════════╗${NC}"
    echo -e "${BOLD}${BLUE}║         Recording Session            ║${NC}"
    echo -e "${BOLD}${BLUE}╚══════════════════════════════════════╝${NC}\n"

    # Show paths before starting
    echo -e "${BOLD}Files will be saved as:${NC}"
    echo -e "  ${BLUE}├─${NC} Audio: $(basename "$OUTPUT_FILE")"
    echo -e "  ${BLUE}├─${NC} Text:  $(basename "$TRANSCRIPT_FILE")"
    [ -n "$PROMPT" ] && echo -e "  ${BLUE}└─${NC} AI:    $(basename "$PROMPT_FILE")"
    echo ""

    # Initialize counter
    echo "0" > "$COUNTER_FILE"
    echo "0" > "$DURATION_FILE"

    # Start recording
    start_recording

    # Main recording loop
    while true; do
        char=$(dd bs=1 count=1 2>/dev/null)
        case "$char" in
            " ")  # Space bar
                toggle_pause
                ;;
            $'\x0a'|$'\x0d')  # Enter key
                break
                ;;
            $'\x03')  # Ctrl+C
                break
                ;;
        esac
    done

    cleanup
