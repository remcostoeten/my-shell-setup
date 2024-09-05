get_mouse_sensitivity() {
  local current=$(gsettings get org.gnome.desktop.peripherals.mouse speed)
  # Remove leading/trailing spaces and quotes
  current=$(echo $current | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//' -e 's/^"//' -e 's/"$//')
  # Convert from 0-1 range to 1-1000 range and round to nearest integer
  local sensitivity=$(echo "scale=0; ($current * 1000) + 0.5" | bc)
  echo $sensitivity
}

set_mouse_sensitivity() {
  local sensitivity=$1

  if ! [[ "$sensitivity" =~ ^[0-9]+$ ]] || [ "$sensitivity" -lt 1 ] || [ "$sensitivity" -gt 1000 ]; then
    echo "Please enter a number between 1 and 1000."
    return 1
  fi

  # Convert 1-1000 range to -1 to 1 range
  local normalized=$(echo "scale=4; ($sensitivity / 500) - 1" | bc)

  gsettings set org.gnome.desktop.peripherals.mouse speed $normalized

  echo "Mouse sensitivity set to $sensitivity"
}

sensitivity() {
  if [ $# -eq 0 ]; then
    get_mouse_sensitivity
  else
    set_mouse_sensitivity $1
  fi
}
