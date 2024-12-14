#!/bin/bash

## autojump
## sudo apt-get install autojump. cat `/usr/share/doc/autojump/README.Debian` for moreinfo
source /usr/share/autojump/autojump.sh

declare -a PLUGINS=(
  # Core plugins
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
  z
  fzf
  autojump

  # Development
  node
  npm
  docker
  docker-compose
  kubectl
  gh

  # Productivity
  extract
  sudo
  web-search
  history-substring-search
  colored-man-pages
  command-not-found
  ripgrep
  fd

  # Custom completions
  zsh-completions
  zsh-history-substring-search

  # Performance & system
  fast-syntax-highlighting
  you-should-use
  auto-notify
  safe-paste
  dirhistory

  # Git enhancements
  git-flow
  gitignore
  git-extras
)

# Installation helper
install_plugins() {
  # Oh My Zsh
  if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  fi

  # Custom plugins
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
  git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
  git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-completions
}

# Plugin configuration
plugin_config() {
  # FZF configuration
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
  export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'

  # Autosuggestions configuration
  export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'
  export ZSH_AUTOSUGGEST_STRATEGY=(history completion)

  # History configuration
  HISTSIZE=10000
  SAVEHIST=10000
  setopt SHARE_HISTORY
}

main() {
  install_plugins
  plugin_config
}

main

