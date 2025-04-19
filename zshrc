# Set dotfiles directory
export DOTFILES_DIR="$HOME/.config/dotfiles/v3"

# Source welcome message and version info
source "${DOTFILES_DIR}/00-initializer/welcome-message.zsh" 2>/dev/null

# Source core files quietly
source "${DOTFILES_DIR}/sourcers/helper-tools.zsh" 2>/dev/null
source "${DOTFILES_DIR}/sourcers/source-scripts.zsh" 2>/dev/null

# Source the version increment script
source "${DOTFILES_DIR}/01-sourcer/version-increment.zsh"