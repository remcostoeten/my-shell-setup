catcopy() {
  if [ -z "$1" ]; then
    echo "Usage: catcopy <filename>"
    return 1
  fi

  if [ ! -f "$1" ]; then
    echo "Error: '$1' is not a valid file."
    return 1
  fi

  cat "$1" | xclip -selection clipboard
  echo "File contents copied to clipboard."
}
