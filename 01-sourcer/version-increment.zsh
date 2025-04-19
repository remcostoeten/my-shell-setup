#!/bin/zsh

# Increment the version number
version_increment() {
    local version_file="${DOTFILES_DIR}/version.txt"
    local current_version

    # Create version file if it doesn't exist
    if [[ ! -f "$version_file" ]]; then
        echo "1.0.0" > "$version_file"
        current_version="1.0.0"
    else
        current_version=$(cat "$version_file")
    fi

    # Split version into major, minor, and patch
    local -a version_parts
    version_parts=(${(s:.:)current_version})
    local major=${version_parts[1]}
    local minor=${version_parts[2]}
    local patch=${version_parts[3]}

    # Increment patch version
    ((patch++))

    # Create new version string
    local new_version="${major}.${minor}.${patch}"

    # Save new version
    echo "$new_version" > "$version_file"

    # Update welcome message version
    local welcome_file="${DOTFILES_DIR}/00-initializer/welcome-message.zsh"
    if [[ -f "$welcome_file" ]]; then
        sed -i '' "s/DOTFILES_VERSION=\".*\"/DOTFILES_VERSION=\"v${new_version}\"/" "$welcome_file"
        sed -i '' "s/LAST_UPDATED=.*/LAST_UPDATED=\$(date \"+%Y-%m-%d %H:%M:%S\")/" "$welcome_file"
    fi

    # Print version info if not in quiet mode
    if [[ -z $DOTFILES_QUIET ]]; then
        echo "🔄 Version incremented: v${current_version} → v${new_version}"
    fi
}

# Create a Git pre-commit hook to auto-increment version
setup_version_hook() {
    local hook_file="${DOTFILES_DIR}/.git/hooks/pre-commit"
    local hook_content='#!/bin/zsh
source "'${DOTFILES_DIR}'/01-sourcer/version-increment.zsh"
version_increment'

    # Create hooks directory if it doesn't exist
    mkdir -p "${DOTFILES_DIR}/.git/hooks"

    # Create or update the pre-commit hook
    echo "$hook_content" > "$hook_file"
    chmod +x "$hook_file"
}

# Setup the hook if we're in the dotfiles directory and it's a git repo
if [[ -d "${DOTFILES_DIR}/.git" ]]; then
    setup_version_hook
fi

for file in "${DOTFILES_DIR}/02-scripts"/*.zsh(N); do
  [[ -f "$file" ]] && source "$file" 2>/dev/null
done







