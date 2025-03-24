function go() {
  if [[ -z "$1" ]]; then
    echo "Usage: go <folder>"
    return 1
  fi

  local folder="$1"

  if [[ ! -d "$folder" ]]; then
    echo "Error: Directory '$folder' does not exist."
    return 1
  fi

  cd "$folder" || return 1
  echo "Changed directory to $folder"

  echo "Installing dependencies..."
  pnpm i

  echo "Starting development server in the background..."

  (pnpm dev || pnpm start) >output.log 2>&1 &
  disown

  echo "Process started in the background. Use 'killall node' to stop all running servers."
}
