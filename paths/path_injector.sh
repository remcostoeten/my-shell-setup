#  Allow execution of a file with sudo privileges
  alias allow='sudo chmod +x $1'
 Connect to a VPN using Tailscale
  alias vpn="tailscale"
 Go to Desktop directory
  alias d="cd ~/Desktop"
 Translate JSON files using a translation service
  alias translate="yarn json-autotranslate --input src/js/i18n/messages/ --type key-based --matcher i18next --directory-structure ngx-translate --service deepl-free --config fb9ed0cc-2782-eaa0-d75b-76d5f8f92f87:fx,less --delete-unused-strings"
 Open a custom cursor application
  alias cursor="cd ~/Programs && ./cursor.AppImage"

#   Set ZSH configuration
 export ZSH=~/.oh-my-zsh
  Set a random theme for the terminal
  PS1='%B%{$fg[yellow]%}%~/ %{$fg_bold[cyan]%}$(git_prompt_info)%{$fg_bold[blue]%}
  %{$reset_color%}%B'
  RPROMPT='%T'
  ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[green]%}"
  ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
  ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}*%{$fg[green]%}"
  ZSH_THEME="dstufft"
 ZSH_THEME="duellj"

#   Set list of themes to load
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
#  )

# #   Set completion options
#  export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
#  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
#  source ~/.oh-my-zsh/oh-my-zsh.sh

# #   bun completions
#  [ -s "/home/remcostoeten/.bun/_bun" ] && source "/home/remcostoeten/.bun/_bun"

#   bun
#  export BUN_INSTALL="$HOME/.bun"
#  export PATH="$BUN_INSTALL/bin:$PATH"
#  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  This loads nvm bash_completion
#  [[ -s /usr/share/autojump/autojump.zsh ]] && source /usr/share/autojump/autojump.zsh

# #   pnpm
#  export PNPM_HOME="/home/remcostoeten/.local/share/pnpm"
#  case ":$PATH:" in
#    *":$PNPM_HOME:"*) ;;
#    *) export PATH="$PNPM_HOME:$PATH" ;;
#  esac
#   pnpm end

#  PATH=~/.console-ninja/.bin:$PATH

# #   Turso
#  export PATH="$PATH:/home/remcostoeten/.turso"
