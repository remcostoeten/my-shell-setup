alias xx='exit'
alias cc='clear'
alias ll='ls -la'
alias l='ls -l'
alias cat='bat $1 -p'
alias zsh='vim ~/.zshrc'
alias szsh='source ~/.zshrc'
alias czsh='code ~/.zshrc'
alias cursor='nohup /home/remcostoeten/Applications/cursor.AppImage > /dev/null 2>&1 &'
alias secret='openssl rand -base64 32 | tr -d "\n" | xclip -selection clipboard'
alias jwt='echo $secret '
createfile() {
  if [ -z "$1" ]; then
    echo "Usage: create <filename.extension>"
    return 1
  fi

  # Create the file
  touch "$1"

  # Add shebang line based on extension
  case "$1" in
  *.sh)
    echo '#!/bin/bash' >"$1"
    ;;
  *.py)
    echo '#!/usr/bin/env python3' >"$1"
    ;;
  *.rb)
    echo '#!/usr/bin/env ruby' >"$1"
    ;;
  *.pl)
    echo '#!/usr/bin/env perl' >"$1"
    ;;
  esac

  # Open in vim
  vim "$1"

  # Make executable if file still exists and has content
  if [ -f "$1" ] && [ -s "$1" ]; then
    sudo chmod +x "$1"
    echo "Made $1 executable"
  fi
}
