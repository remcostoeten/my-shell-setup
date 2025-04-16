# FZF (Fuzzy Finder) Configuration
# Powerful command-line fuzzy finder
# Created: $(date '+%Y-%m-%d')

# Initialize fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Set up fzf key bindings and completion
if type rg &> /dev/null; then
  export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git/*"'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
fi

# Configure fzf appearance
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border --preview "bat --style=numbers --color=always --line-range :500 {}"'

# Fuzzy find files
ff() {
  local file
  file=$(fzf --preview 'bat --style=numbers --color=always {}' --preview-window '~3')
  if [ -n "$file" ]; then
    ${EDITOR:-vim} "$file"
  fi
}

# Fuzzy find in history
fh() {
  print -z $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | sed -E 's/ *[0-9]*\*? *//' | sed -E 's/\\/\\\\/g')
}

# Fuzzy find and cd into directory
fd() {
  local dir
  dir=$(find ${1:-.} -path '*/\.*' -prune -o -type d -print 2> /dev/null | fzf +m) &&
  cd "$dir"
}

# Usage examples (as comments for reference):
# CTRL+T    - Paste selected files/folders into command line
# CTRL+R    - Search command history
# ALT+C     - CD into selected directory
# ff        - Find file and open in editor
# fh        - Search command history interactively
# fd        - Find and cd into directory 