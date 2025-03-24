export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Force Node.js version 22.14.0
DESIRED_NODE_VERSION="22.14.0"

# Clear any existing Node.js version and shell hash
nvm deactivate >/dev/null 2>&1
hash -r 2>/dev/null

# Remove default alias and set new one
nvm unalias default >/dev/null 2>&1
nvm alias default $DESIRED_NODE_VERSION >/dev/null 2>&1

# Ensure version is installed
nvm install $DESIRED_NODE_VERSION >/dev/null 2>&1

# Force the version switch with complete PATH reset
nvm use $DESIRED_NODE_VERSION --silent --delete-prefix
export PATH="$NVM_DIR/versions/node/v$DESIRED_NODE_VERSION/bin:$PATH"

# Clear commands hash table
hash -r 2>/dev/null

# Verify and force correct version
if [ "$(node -v)" != "v$DESIRED_NODE_VERSION" ]; then
    echo "Warning: Node.js version mismatch. Forcing version $DESIRED_NODE_VERSION"
    # Double enforce
    nvm use $DESIRED_NODE_VERSION --silent --delete-prefix
    export PATH="$NVM_DIR/versions/node/v$DESIRED_NODE_VERSION/bin:$PATH"
    hash -r 2>/dev/null
fi

# Prevent automatic version switching
export NVM_AUTO_USE=false

# Auto-switch Node version based on .nvmrc
load_nvmrc() {
    local nvmrc_path
    nvmrc_path="$(nvm_find_nvmrc)"

    if [ -n "$nvmrc_path" ]; then
        local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")
        local nvmrc_node_version_without_prefix=${nvmrc_node_version#v}

        if [ "$nvmrc_node_version" = "N/A" ]; then
            nvm install
        elif [ "$(nvm current)" != "$nvmrc_node_version" ]; then
            nvm use "$nvmrc_node_version_without_prefix"
        fi
    elif [ "$(nvm current)" != "$(nvm version default)" ]; then
        nvm use default
    fi
}

# Add directory change hook
autoload -U add-zsh-hook
add-zsh-hook chpwd load_nvmrc

# Initial load
load_nvmrc
