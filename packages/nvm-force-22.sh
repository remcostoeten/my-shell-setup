# NVM setup and Node.js v22 enforcer
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # Load NVM

# Force Node.js v22
NODE_VERSION="22"
nvm install $NODE_VERSION --silent
nvm alias default $NODE_VERSION --silent
nvm use $NODE_VERSION --silent

# Ensure PATH is set correctly
export PATH="$NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH"

# Prevent version switching
export NVM_AUTO_USE=false
