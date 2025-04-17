#!/bin/zsh

# Version management script
# Handles version updates and display

# Colors and emojis for logging
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Emojis
ROCKET="🚀"
SPARKLES="✨"
GEAR="⚙️"
WARNING="⚠️"
CHECK="✅"

# Helper function for logging
log() {
    local type=$1
    local message=$2
    case $type in
        "success")
            echo -e "${GREEN}${CHECK} ${message}${NC}"
            ;;
        "info")
            echo -e "${BLUE}${GEAR} ${message}${NC}"
            ;;
        "warning")
            echo -e "${YELLOW}${WARNING} ${message}${NC}"
            ;;
        "error")
            echo -e "${RED}${WARNING} ${message}${NC}"
            ;;
        "update")
            echo -e "${GREEN}${ROCKET} ${message}${NC}"
            ;;
    esac
}

# Function to read current version
get_version() {
    source "$SCRIPT_DIR/initialize/version.txt"
    echo $VERSION
}

# Function to update version file
update_version() {
    local new_version=$1
    echo "VERSION=\"$new_version\"" > "$SCRIPT_DIR/initialize/version.txt"
    echo "LAST_UPDATED=\"$(date '+%Y-%m-%d %H:%M:%S')\"" >> "$SCRIPT_DIR/initialize/version.txt"
    log "success" "Updated version to $new_version"
}

# Function to increment version
increment_version() {
    local version=$(get_version)
    local major=$(echo $version | cut -d. -f1)
    local minor=$(echo $version | cut -d. -f2)
    local patch=$(echo $version | cut -d. -f3)
    
    case $1 in
        "major")
            major=$((major + 1))
            minor=0
            patch=0
            ;;
        "minor")
            minor=$((minor + 1))
            patch=0
            ;;
        "patch")
            patch=$((patch + 1))
            ;;
    esac
    
    echo "$major.$minor.$patch"
}

# Function to count commits
get_commit_counts() {
    local current_hash="5ec0091eaf556bc9e1066781af96b85b1a78bdf0"
    local newer_commits=$(git rev-list --count HEAD...${current_hash})
    local older_commits=$(git rev-list --count ${current_hash})
    echo "${newer_commits}:${older_commits}"
}

# Function to show help menu
show_help() {
    local category=$1
    
    case $category in
        "version")
            echo -e "${BLUE}${GEAR} Version Management Commands:${NC}"
            echo -e "  ${GREEN}shell --version${NC}              Display current version info"
            echo -e "  ${GREEN}shell --update patch${NC}         Increment patch version (0.0.X)"
            echo -e "  ${GREEN}shell --update minor${NC}         Increment minor version (0.X.0)"
            echo -e "  ${GREEN}shell --update major${NC}         Increment major version (X.0.0)"
            echo -e "  ${GREEN}shell --set-version X.Y.Z${NC}    Set specific version number"
            ;;
        "git")
            echo -e "${BLUE}${GEAR} Git Integration Commands:${NC}"
            echo -e "  ${GREEN}fbr${NC}                         Fuzzy find and checkout git branches"
            echo -e "  ${GREEN}fga${NC}                         Fuzzy find and stage git files"
            echo -e "  ${GREEN}git status${NC}                  Show git status with colors"
            ;;
        "navigation")
            echo -e "${BLUE}${GEAR} Navigation Commands:${NC}"
            echo -e "  ${GREEN}z <pattern>${NC}                 Smart jump to frequent directories"
            echo -e "  ${GREEN}zi${NC}                         Interactive directory selection"
            echo -e "  ${GREEN}fd${NC}                         Fuzzy find directories"
            echo -e "  ${GREEN}ff${NC}                         Fuzzy find files"
            ;;
        "shell")
            echo -e "${BLUE}${GEAR} Shell Enhancement Commands:${NC}"
            echo -e "  ${GREEN}fh${NC}                         Fuzzy search command history"
            echo -e "  ${GREEN}CTRL+R${NC}                     Search command history"
            echo -e "  ${GREEN}CTRL+T${NC}                     Fuzzy find files"
            echo -e "  ${GREEN}ALT+C${NC}                      Fuzzy find and cd into directory"
            ;;
        *)
            echo -e "${BLUE}${SPARKLES} remco's Shell Help Menu${NC}"
            echo -e "${YELLOW}Usage: shell --help [category]${NC}"
            echo
            echo -e "${BLUE}Available Categories:${NC}"
            echo -e "  ${GREEN}version${NC}     - Version management commands"
            echo -e "  ${GREEN}git${NC}         - Git integration commands"
            echo -e "  ${GREEN}navigation${NC}  - Directory and file navigation"
            echo -e "  ${GREEN}shell${NC}       - Shell enhancements and shortcuts"
            echo
            echo -e "${BLUE}Quick Commands:${NC}"
            echo -e "  ${GREEN}shell --help${NC}     Show this help menu"
            echo -e "  ${GREEN}shell --version${NC}  Show version information"
            echo
            echo -e "${YELLOW}Tip: Use 'shell --help <category>' for detailed commands${NC}"
            ;;
    esac
}

# Main version management function
version_manager() {
    local command=$1
    local arg=$2
    
    case $command in
        "--help"|"-h"|"help"|"--h")
            show_help "$arg"
            ;;
        "--update")
            local current_version=$(get_version)
            local new_version
            case $arg in
                "major")
                    new_version=$(increment_version "major")
                    log "update" "Incrementing major version: $current_version → $new_version"
                    ;;
                "minor")
                    new_version=$(increment_version "minor")
                    log "update" "Incrementing minor version: $current_version → $new_version"
                    ;;
                "patch")
                    new_version=$(increment_version "patch")
                    log "update" "Incrementing patch version: $current_version → $new_version"
                    ;;
                *)
                    log "error" "Invalid update type. Use: major, minor, or patch"
                    show_help "version"
                    return 1
                    ;;
            esac
            update_version $new_version
            ;;
            
        "--set-version")
            if [[ $arg =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
                log "info" "Setting version to $arg"
                update_version $arg
            else
                log "error" "Invalid version format. Use: X.Y.Z (e.g., 1.0.0)"
                show_help "version"
                return 1
            fi
            ;;
            
        "--version"|"-v")
            local version=$(get_version)
            source "$SCRIPT_DIR/initialize/version.txt"
            local commit_counts=(${(s/:/)$(get_commit_counts)})
            local newer_commits=$commit_counts[1]
            local older_commits=$commit_counts[2]
            
            echo -e "${BLUE}${SPARKLES} remco's shell v2${NC}"
            echo -e "${BLUE}since 13 april 2025 • ${newer_commits} commits${NC}"
            echo -e "${BLUE}last updated: $LAST_UPDATED${NC}"
            echo -e "${YELLOW}Tip: Use 'shell --help' for available commands${NC}"
            ;;
            
        *)
            log "error" "Unknown command. Use 'shell --help' for available commands"
            return 1
            ;;


            
    esac
}

# Create shell function for user
shell() {
    version_manager "$@"
} 