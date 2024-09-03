# copypwd function to copy the current path or file path to clipboard
copypwd() {
  if [ "$1" == "--f" ] || [ "$1" == "--file" ]; then
    if [ -z "$2" ]; then
      echo "Usage: copypwd --f <filename>"
      return 1
    fi

    if [ ! -f "$2" ]; then
      echo "Error: '$2' is not a valid file."
      return 1
    fi

    pwd | tr -d '\n' | xclip -selection clipboard
    echo -n "/" >> /tmp/copypath
    echo "$2" >> /tmp/copypath
    cat /tmp/copypath | xclip -selection clipboard
    rm /tmp/copypath
    echo "File path copied to clipboard: $(pwd)/$2"
  else
    pwd | tr -d '\n' | xclip -selection clipboard
    echo "Current path copied to clipboard: $(pwd)"
  fi
}

# Alias for copypwd
alias cpwd=copypwd
alias copypwd=cpwd
