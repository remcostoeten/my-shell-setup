#!/bin/bash

#alias to code directory
alias co='cd ~/code'

# Shortcuts for navigating directories
alias .='cd'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias .......='cd ../../../../../..'
alias ........='cd ../../../../../../..'
alias .........='cd ../../../../../../../..'
alias ..........='cd ../../../../../../../../..'
alias ...........='cd ../../../../../../../../../..'

# Shortcuts for navigating to common directories
alias desktop='cd ~/Desktop'
alias downloads='cd ~/Downloads'
alias documents='cd ~/Documents'
alias pictures='cd ~/Pictures'
alias videos='cd ~/Videos'
alias music='cd ~/Music'
alias home='cd ~'
alias root='cd /'

# Shortcuts for development environments
alias d='cd ~/dev'
alias dd='cd ~/Downloads/projects/;pnpmm dev'

alias downloads='cd ~/Downloads'
alias projects='cd ~/projects'
alias zshsetup='cd ~/projects/zsh-setup'
alias code='cd ~/code'
alias project='cd ~/code/notevault'

# Open cursor IDE
#nohup runs without being dependent on the terminal, allowing you to close the terminal session while keeping the program running.
alias cursor='/home/remcostoeten/Applications/cursor.AppImage > /dev/null 2>&1 &'
function startauth() {
  # Change to the project directory
  cd ~/Downloads/project

  # Open the project in Cursor in the background
  cursor . &

  # Run pnpm dev in the background
  pnpm dev &

  # Optional: return to the previous directory
  cd -
}
