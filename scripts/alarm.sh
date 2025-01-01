alarm() {
  local seconds=0
  local message="Time is up!"
  local title="Alarm"

  # Extract number and unit
  local number=$(echo $1 | sed 's/[hms]//g')
  local unit=$(echo $1 | sed 's/[0-9]//g')

  # Convert to seconds
  case $unit in
  h) seconds=$((number * 3600)) ;;
  m) seconds=$((number * 60)) ;;
  s) seconds=$((number)) ;;
  *) echo "Invalid format. Use h, m, or s (e.g., 1h, 30m, 45s)" && return 1 ;;
  esac

  # Get custom message if provided
  if [[ $# -gt 1 ]]; then
    message="${@:2}"
  fi

  echo "⏰ Alarm set for $1 ($seconds seconds)"
  sleep $seconds && notify-send "$title" "$message"
}
