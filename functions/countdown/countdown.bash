# Function to parse time input and perform countdown
countdown() {
  local time_str=$1
  local total_seconds=0

  # Parse input (supports format like 10s, 5m, 1m30s)
  if [[ $time_str =~ ^([0-9]+)s$ ]]; then
    total_seconds=${BASH_REMATCH[1]}
  elif [[ $time_str =~ ^([0-9]+)m$ ]]; then
    total_seconds=$((${BASH_REMATCH[1]} * 60))
  elif [[ $time_str =~ ^([0-9]+)m([0-9]+)s$ ]]; then
    total_seconds=$((${BASH_REMATCH[1]} * 60 + ${BASH_REMATCH[2]}))
  else
    echo "Invalid format. Use formats like 10s, 5m, 1m30s."
    return 1
  fi

  # Countdown loop
  while [ $total_seconds -gt 0 ]; do
    echo -ne "Time remaining: $(date -u -d @${total_seconds} +%T)\r"
    sleep 1
    ((total_seconds--))
  done

  echo -e "\nTime's up!"
}

# Create an alias for countdown
alias countdown='countdown'
