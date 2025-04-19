# Set dotfiles directory
export DOTFILES_DIR="$HOME/.config/dotfiles/v3"

# Source the theme
source "${DOTFILES_DIR}/00-initializer/theme.zsh" 2>/dev/null

# Source welcome message and version info
source "${DOTFILES_DIR}/00-initializer/welcome-message.zsh" 2>/dev/null

# Source core files quietly
source "${DOTFILES_DIR}/sourcers/source-scripts" 2>/dev/null
source ~/.config/dotfiles/v3/sourcers/source-helpers 2>/dev/null


source "${DOTFILES_DIR}/01-sourcer/version-increment.zsh"