nvidia_fan_control() {
  local gpu_count=$(nvidia-smi --query-gpu=count --format=csv,noheader,nounits)

  # Function to set fan speed
  set_fan_speed() {
    local gpu=$1
    local speed=$2
    if [ $speed -lt 0 ] || [ $speed -gt 100 ]; then
      echo "Error: Fan speed for GPU $gpu must be between 0 and 100"
      return 1
    fi
    nvidia-settings -a "[gpu:$gpu]/GPUFanControlState=1" -a "[fan:$gpu]/GPUTargetFanSpeed=$speed" >/dev/null
    echo "Set GPU $gpu fan speed to $speed%"
  }

  # Parse arguments
  if [ $# -eq 0 ]; then
    echo "Usage: fans SPEED               (set both fans to SPEED)"
    echo "       fans SPEED1 SPEED2       (set fan1 to SPEED1 and fan2 to SPEED2)"
    echo "       fan1 SPEED               (set fan1 to SPEED)"
    echo "       fan2 SPEED               (set fan2 to SPEED)"
    return 1
  fi

  case "$1" in
  fans)
    if [ $# -eq 2 ]; then
      local speed=${2%\%}
      set_fan_speed 0 $speed
      set_fan_speed 1 $speed
    elif [ $# -eq 3 ]; then
      local speed1=${2%\%}
      local speed2=${3%\%}
      set_fan_speed 0 $speed1
      set_fan_speed 1 $speed2
    else
      echo "Invalid number of arguments for 'fans'"
      return 1
    fi
    ;;
  fan1)
    if [ $# -ne 2 ]; then
      echo "Invalid number of arguments for 'fan1'"
      return 1
    fi
    local speed=${2%\%}
    set_fan_speed 0 $speed
    ;;
  fan2)
    if [ $# -ne 2 ]; then
      echo "Invalid number of arguments for 'fan2'"
      return 1
    fi
    local speed=${2%\%}
    set_fan_speed 1 $speed
    ;;
  *)
    echo "Invalid command. Use 'fans', 'fan1', or 'fan2'."
    return 1
    ;;
  esac
}

# Aliases for fan control
alias fans='nvidia_fan_control fans'
alias fan1='nvidia_fan_control fan1'
alias fan2='nvidia_fan_control fan2'
