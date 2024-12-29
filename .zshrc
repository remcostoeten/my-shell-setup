# Path definitions
export PATH="$HOME/.local/bin:$PATH"
export PATH="$PATH:/usr/local/go/bin"
export PATH="$PATH:/home/remcostoeten/.turso"
export PNPM_HOME="/home/remcostoeten/.local/share/pnpm"
export GOPATH="$HOME/go"
export PATH="$PATH:$GOPATH/bin"

# Add pnpm to path if not already present
case ":$PATH:" in
    *":$PNPM_HOME:"*) ;;
    *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# Export script paths
export SCRIPTS_PATH="$HOME/projects/zsh-setup/scripts"
export ZSH_SETUP_PATH="$HOME/projects/zsh-setup"

# Source main configuration
source "$ZSH_SETUP_PATH/main_injector.sh"
