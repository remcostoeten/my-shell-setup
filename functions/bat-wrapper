# Optimized bat wrapper function
bat() {
  # --- Configuration ---
  # Define ANSI color codes
  local color_reset="\e[0m"
  local color_red="\e[0;31m"
  local color_green="\e[0;32m"
  local color_yellow="\e[0;33m"
  local color_blue="\e[0;34m"
  local color_cyan="\e[0;36m"
  local color_bold_green="\e[1;32m"
  local color_bold_yellow="\e[1;33m"
  local color_bold_blue="\e[1;34m"

  # --- State Variables ---
  local filename=""
  local copy_target="" # 'content', 'name', 'path'
  local line_range="" # For bat's -r option
  local show_help=0
  local bat_opts=()   # Array to hold options for the real bat command

  # --- Helper: Detect Clipboard Command ---
  local clipboard_cmd=""
  if command -v pbcopy >/dev/null 2>&1; then
    clipboard_cmd="pbcopy"
  elif command -v wl-copy >/dev/null 2>&1; then
    clipboard_cmd="wl-copy"
  elif command -v xclip >/dev/null 2>&1; then
    clipboard_cmd="xclip -selection clipboard"
  fi

  # --- Helper: Show Help Menu ---
  help_menu() {
    echo -e "${color_bold_green}Usage: bat [options] [filename] [bat options]${color_reset}"
    echo "  Displays file content with syntax highlighting, adding range and copy features."
    echo
    echo -e "${color_bold_yellow}Wrapper Options:${color_reset}"
    echo -e "  ${color_cyan}--first N, -f N${color_reset}      Show only the first N lines (uses bat -r :N)."
    echo -e "  ${color_cyan}--last N, -l N, -L N${color_reset}  Show only the last N lines (uses bat -r 'N:')."
    echo -e "  ${color_cyan}N:M${color_reset}                 Show lines N to M (uses bat -r N:M)."
    echo -e "  ${color_cyan}--copy, -c${color_reset}           Copy file content to clipboard."
    echo -e "  ${color_cyan}--copyname, --cn${color_reset}     Copy the filename to clipboard."
    echo -e "  ${color_cyan}--copypath, --cp${color_reset}     Copy the full file path to clipboard."
    echo -e "  ${color_cyan}--help, -h${color_reset}           Show this help menu."
    echo
    echo -e "${color_bold_blue}Examples:${color_reset}"
    echo "  bat --first 10 myfile.txt"
    echo "  bat myfile.txt -l 20 --theme='Nord'" # Pass --theme to bat
    echo "  bat script.py 50:100"
    echo "  bat config.yaml --copy"
    echo "  bat --copypath important.docx"
    echo
    echo "Any unrecognized options are passed directly to the 'bat' command."
  }

  # --- Check Dependencies ---
  if ! command -v bat >/dev/null 2>&1; then
    echo -e "${color_red}Error: 'bat' command not found. Please install bat.${color_reset}" >&2
    echo "Installation instructions: https://github.com/sharkdp/bat#installation" >&2
    return 1
  fi

  # --- Argument Parsing Loop ---
  while [[ $# -gt 0 ]]; do
    case "$1" in
      # --- Help ---
      --help|-h)
        show_help=1
        shift # consume --help/-h
        # Stop processing if help is requested, show menu later
        break
        ;;

      # --- Line Ranges ---
      --first|-f)
        if [[ -n "$2" && "$2" =~ ^[0-9]+$ ]]; then
          line_range=":$2"
          shift 2 # consume --first/-f and N
        else
          echo -e "${color_red}Error: Missing or invalid number of lines for '$1'.${color_reset}" >&2
          return 1
        fi
        ;;
      --last|-l|-L)
        if [[ -n "$2" && "$2" =~ ^[0-9]+$ ]]; then
          # Calculate starting line number later, after filename is known
          # For now, store the request type and number
          line_range="last:$2" # Special flag to be processed later
          shift 2 # consume --last/-l/-L and N
        else
          echo -e "${color_red}Error: Missing or invalid number of lines for '$1'.${color_reset}" >&2
          return 1
        fi
        ;;
      # N:M range (e.g., 10:20) - Check pattern carefully
      [0-9]*:[0-9]*)
         # Validate more strictly it's digits:digits
         if [[ "$1" =~ ^[0-9]+:[0-9]+$ ]]; then
            line_range="$1"
            shift # consume N:M
         else
            # Not a valid N:M range, treat as filename or bat option later
            bat_opts+=("$1")
            shift
         fi
         ;;

      # --- Copy Operations ---
      --copy|-c)
        copy_target="content"
        shift # consume --copy/-c
        ;;
      --copyname|--cn)
        copy_target="name"
        shift # consume --copyname/--cn
        ;;
      --copypath|--cp)
        copy_target="path"
        shift # consume --copypath/--cp
        ;;

      # --- Pass-through or Filename ---
      # Match arguments starting with '-' as potential bat options
      -*)
        bat_opts+=("$1")
        shift # consume the option
        # If the option potentially takes an argument (common case, heuristic)
        # and the next argument doesn't start with '-', assume it's the value
        if [[ $# -gt 0 && "$1" != -* ]]; then
           bat_opts+=("$1")
           shift
        fi
        ;;
      # Otherwise, assume it's the filename
      *)
        if [[ -z "$filename" ]]; then
          filename="$1"
        else
          # Already have a filename, treat as extra arg (maybe for bat?)
          # Or maybe it's an error? For simplicity, pass to bat.
          # If you wanted stricter checking, you could error here.
          bat_opts+=("$1")
        fi
        shift # consume the argument
        ;;
    esac
  done

  # --- Action Execution ---

  # 1. Show Help
  if [[ $show_help -eq 1 ]]; then
    help_menu
    return 0
  fi

  # 2. Check if Filename was Provided
  if [[ -z "$filename" ]]; then
    echo -e "${color_red}Error: Filename is required.${color_reset}" >&2
    help_menu
    return 1
  fi

  # 3. Check if File Exists (unless copying name/path)
  if [[ "$copy_target" != "name" && "$copy_target" != "path" && ! -e "$filename" ]]; then
    echo -e "${color_red}Error: File not found: '$filename'${color_reset}" >&2
    return 1
  fi

  # 4. Handle Copy Operations
  if [[ -n "$copy_target" ]]; then
    if [[ -z "$clipboard_cmd" ]]; then
      echo -e "${color_red}Error: Cannot copy, no clipboard command found (pbcopy, wl-copy, xclip).${color_reset}" >&2
      return 1
    fi
    local success_msg=""
    case "$copy_target" in
      content)
        # Check file exists before catting
        if [[ ! -e "$filename" ]]; then
           echo -e "${color_red}Error: File not found: '$filename'${color_reset}" >&2
           return 1
        fi
        # Use '<' for redirection instead of 'cat |'
        < "$filename" "$clipboard_cmd"
        success_msg="Content"
        ;;
      name)
        # Extract basename in case a path was given
        local fname_base=$(basename -- "$filename")
        echo -n "$fname_base" | "$clipboard_cmd"
        success_msg="Filename"
        ;;
      path)
        if ! command -v realpath >/dev/null 2>&1; then
           echo -e "${color_red}Error: 'realpath' command not found, cannot copy full path.${color_reset}" >&2
           return 1
        fi
        # Check file exists before getting real path
        if [[ ! -e "$filename" ]]; then
           echo -e "${color_red}Error: File/Directory not found: '$filename'${color_reset}" >&2
           return 1
        fi
        realpath "$filename" | "$clipboard_cmd"
        success_msg="Filepath"
        ;;
    esac
    echo -e "${color_green}Success: ${success_msg} copied to clipboard.${color_reset}"
    return 0 # Copy action complete
  fi

  # 5. Handle Display Operations (including ranges)

  # Process special 'last:N' range flag now that we have the file
  if [[ "$line_range" == last:* ]]; then
      local last_n=${line_range#last:}
      local line_count
      # Handle potential errors with wc
      if ! line_count=$(wc -l < "$filename" 2>/dev/null); then
          echo -e "${color_red}Error: Could not count lines in '$filename'.${color_reset}" >&2
          return 1
      fi
      # Trim leading/trailing whitespace from wc output
      line_count=$(echo "$line_count" | awk '{$1=$1};1')
      local start_line=$(( line_count - last_n + 1 ))
      # Handle requesting more lines than exist or zero lines
      [[ $start_line -lt 1 ]] && start_line=1
      line_range="${start_line}:" # Convert to bat's N: format
  fi

  # Add the line range option to bat if specified
  if [[ -n "$line_range" ]]; then
    bat_opts+=("--line-range" "$line_range")
  fi

  # Execute the real bat command
  command bat "${bat_opts[@]}" "$filename"
}