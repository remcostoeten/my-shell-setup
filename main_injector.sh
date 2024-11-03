#!/bin/bash
## move over to seperate module

alias cursor='nohup /home/remcostoeten/Applications/cursor.AppImage > /dev/null 2>&1 &'

# Initialize welcome message
source /home/remcostoeten/projects/zsh-setup/_welcome-message.sh

source /home/remcostoeten/projects/zsh-setup/alias/alias_injector.sh

# Initialize zsh-help-menu which is available when typing 'zshhelp' in the terminal
source /home/remcostoeten/projects/zsh-setup/initialize/_zsh-help-menu.sh

# Initialize all aliases
if ! source /home/remcostoeten/projects/zsh-setup/alias/alias_injector.sh; then
  handle_error 1 "Failed to source alias_injector.sh"
fi

# Initialize all utils
if ! source /home/remcostoeten/projects/zsh-setup/utils/utils_injector.sh; then
  handle_error 2 "Failed to source utils_injector.sh"
fi

# Initialize all plugins
plugins=(
  git
  nvm
  aliases
  colorize
  gh
  sudo
  extract
  web-search
  history-substring-search
)
