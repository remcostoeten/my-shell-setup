#!/bin/bash

# CLI shortcuts
alias ll='ls -la'
alias la='ls -A'
alias l='ls'
alias c='clear'

# Function to create aliases for navigating up to 9 levels
create_cd_aliases() {
  for i in {1..9}; do
    dots=$(printf '%*s' "$i" | tr ' ' '.')
    alias "$dots"="cd $(printf '../%.0s' $(seq 1 $i))"
  done
}

# Call the function to create the aliases
create_cd_aliases

# Dev shortcuts
alias p='pnpm'
alias dev='pnpm dev'
alias i='pnpm install'
alias a='pnpm add'
alias b='bun'
alias bi='bun install'
alias restart='rm -rf node_modules .next; pnpm install; pnpm dev'
alias rmall='rm -rf node_modules; [ -d .next ] && rm -rf .next'
alias re='rm -rf node_modules; [ -d .next ] && rm -rf .next && pnpm install && pnpm dev'
alias d='docker'
alias dc='docker-compose'
alias dcu='docker-compose up'
alias dstart='docker-compose down'
alias dstop='docker-compose build'
alias dshow='docker ps'
alias stopdocker='docker stop $(docker ps -aq)'
alias rmdocker='docker rm $(docker ps -aq)'

# Database shortcuts
alias pgstart='sudo service postgresql start'
alias pgstop='sudo service postgresql stop'
alias pgstatus='sudo service postgresql status'

# System shortcuts
alias update='sudo apt update && sudo apt upgrade -y'
alias install='sudo apt install'
alias remove='sudo apt remove'
alias ports='netstat -tulanp'
alias mem='free -h'
alias disk='df -h'
alias cpu='htop'

# Navigation shortcuts
alias home='cd ~'
alias devdir='cd ~/dev'
alias projects='cd ~/projects'
alias desktop='cd ~/Desktop'
alias pictures='cd ~/Pictures'
alias videos='cd ~/Videos'
alias config='cd ~/.config/'
alias downloads='cd ~/Downloads/'

# File operations
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'
alias mkdir='mkdir -p'
alias md='mkdir'
alias rd='rmdir'

# Network
alias myip='curl http://ipecho.net/plain; echo'
alias ping='ping -c 5'
alias listen='lsof -i -P | grep LISTEN'

# Search shortcuts
alias ff='find . -type f -name'
alias fd='find . -type d -name'
alias ftext='grep -r'

# Misc
alias python='python3'
alias click='python /home/remcostoeten/autoclick.py'
# Help function
function show_shortcuts() {
  echo "Available shortcuts:"
  echo "==================="
  echo "Development:"
  echo "  nrd     - npm run dev"
  echo "  pnd     - pnpm dev"
  echo "  yd      - yarn dev"
  echo "  nr      - npm run"
  echo "  pn      - pnpm"
  echo "  y       - yarn"
  echo ""
  echo "Git:"
  echo "  ga      - git add"
  echo "  gc      - git add + commit + push"
  echo "  gp      - git push"
  echo "  gpl     - git pull"
  echo "  gs      - git status"
  echo ""
  echo "Docker:"
  echo "  d       - docker"
  echo "  dc      - docker-compose"
  echo "  dcu     - docker-compose up"
  echo "  dcd     - docker-compose down"
  echo "  dcb     - docker-compose build"
  echo "  dps     - docker ps"
  echo "  dex     - docker exec -it"
  echo "  dl      - docker logs"
  echo "  dprune  - docker system prune -af"
  echo ""
  echo "Database:"
  echo "  pgstart  - start postgresql"
  echo "  pgstop   - stop postgresql"
  echo "  pgstatus - check postgresql status"
  echo ""
  echo "System:"
  echo "  update   - update & upgrade system"
  echo "  install  - install package"
  echo "  remove   - remove package"
  echo "  mem      - show memory usage"
  echo "  disk     - show disk usage"
  echo "  cpu      - show cpu usage (htop)"
  echo ""
  echo "Navigation:"
  echo "  home     - go to home directory"
  echo "  dev      - go to dev directory"
  echo "  projects - go to projects directory"
  echo "  ..       - go up one directory"
  echo "  ...      - go up two directories"
  echo "  ....     - go up three directories"
  echo "  .....    - go up four directories"
  echo ""
  echo "File Operations:"
  echo "  extract  - extract any compressed file"
  echo "  dsize    - show directory size"
  echo "  dsort    - sort directories by size"
  echo "  cp       - copy with confirmation"
  echo "  mv       - move with confirmation"
  echo "  rm       - remove with confirmation"
  echo "  md       - make directory"
  echo "  rd       - remove directory"
  echo ""
  echo "Network:"
  echo "  myip     - show public IP"
  echo "  ping     - ping with 5 packets"
  echo "  ports    - show open ports"
  echo "  listen   - show listening ports"
  echo ""
  echo "Search:"
  echo "  ff       - find file by name"
  echo "  fd       - find directory by name"
  echo "  ftext    - find text in files"
  echo ""
  echo "Process Management:"
  echo "  psa      - show all processes"
  echo "  psg      - search processes"
  echo "  kill9    - force kill process"
  echo ""
  echo "Quick Shortcuts:"
  echo "  p        - go to projects directory"
  echo "  xx/x/q   - exit terminal"
  echo "  :q/:wq   - vim-style exit"
  echo "  v        - nvim"
  echo "  zshrc    - edit ~/.zshrc"
  echo "  zshalias - edit aliases"
  echo "  src      - source ~/.zshrc"
  echo "  t        - tsc --noEmit"
  echo "  click    - Hold b to spam left mouse:wq"
  echo "Type 'shelp' to see this menu again"
}

alias shelp='show_shortcuts'

# Extraction shortcuts
function extract() {
  if [ -f "$1" ]; then
    case $1 in
    *.tar.bz2) tar xjf "$1" ;;
    *.tar.gz) tar xzf "$1" ;;
    *.bz2) bunzip2 "$1" ;;
    *.rar) unrar x "$1" ;;
    *.gz) gunzip "$1" ;;
    *.tar) tar xf "$1" ;;
    *.tbz2) tar xjf "$1" ;;
    *.tgz) tar xzf "$1" ;;
    *.zip) unzip "$1" ;;
    *.Z) uncompress "$1" ;;
    *.7z) 7z x "$1" ;;
    *) echo "'$1' cannot be extracted via extract()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# Directory size shortcuts
alias dsize='du -sh'             # Size of current directory
alias dsort='du -sh * | sort -h' # Sort directories by size

# Process management
alias psa='ps aux'
alias psg='ps aux | grep'
alias kill9='kill -9'

# Quick directory shortcuts
'cd ~/projects'
alias xx='exit'
alias x='exit'
alias q='exit'

# Common typos and shortcuts
alias :q='exit'
alias :wq='exit'
alias vim='nvim'
alias v='nvim'

# Quick edit shortcuts
alias zshrc='${EDITOR:-vim} ~/.zshrc'
alias zshalias='${EDITOR:-vim} ~/projects/zsh-setup/alias/_shortcuts.sh'

# Quick source
alias src='source ~/.zshrc'
