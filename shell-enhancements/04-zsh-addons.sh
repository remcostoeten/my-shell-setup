# ZSH Addons Configuration
# Additional ZSH features and plugins
# Created: $(date '+%Y-%m-%d')

# Load zsh-autosuggestions
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# Load zsh-syntax-highlighting (must be loaded after other widgets)
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Initialize thefuck
eval $(thefuck --alias)

# Custom key bindings for better navigation
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word

# Auto-completion settings
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' # Case insensitive tab completion
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"   # Colored completion
zstyle ':completion:*' rehash true                        # automatically find new executables
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

# Usage examples (as comments for reference):
# <TAB>     - Show completion menu
# CTRL+←/→  - Move between words
# ↑/↓       - Search history with current prefix
# fuck      - Correct previous command 