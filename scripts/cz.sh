#!/bin/bash

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
GRAY='\033[0;90m'
NC='\033[0m' # No Color
BOLD='\033[1m'

# Help menu function
display_help() {
    echo -e "${BOLD}${BLUE}╔════════════════════════════════════════════════╗${NC}"
    echo -e "${BOLD}${BLUE}║             Git Commit Helper 🚀               ║${NC}"
    echo -e "${BOLD}${BLUE}╚════════════════════════════════════════════════╝${NC}\n"

    echo -e "${BOLD}USAGE:${NC}"
    echo -e "  ${CYAN}cz${NC} [options]\n"

    echo -e "${BOLD}OPTIONS:${NC}"
    echo -e "  ${GREEN}--help${NC}        Show this help message"
    echo -e "  ${GREEN}--from${NC}        Specify source directory"
    echo -e "  ${GREEN}--depth${NC}       Set search depth"
    echo -e "  ${GREEN}--ext${NC}         Filter by file extension"
    echo -e "  ${GREEN}--folder${NC}      Search only folders"
    echo -e "  ${GREEN}--string${NC}      Search for specific string"
    echo -e "  ${GREEN}--max-size${NC}    Filter by maximum file size"
    echo -e "  ${GREEN}--last-used${NC}   Sort by last used\n"

    echo -e "${BOLD}COMMIT TYPES:${NC}"
    echo -e "  ${PURPLE}feat${NC}     ➕ A new feature"
    echo -e "  ${PURPLE}fix${NC}      🔧 A bug fix"
    echo -e "  ${PURPLE}docs${NC}     📚 Documentation changes"
    echo -e "  ${PURPLE}style${NC}    💅 Code style changes"
    echo -e "  ${PURPLE}refactor${NC} ♻️  Code refactoring"
    echo -e "  ${PURPLE}perf${NC}     ⚡️ Performance improvements"
    echo -e "  ${PURPLE}test${NC}     🧪 Testing related changes"
    echo -e "  ${PURPLE}build${NC}    🏗️  Build system changes"
    echo -e "  ${PURPLE}ci${NC}       👷 CI/CD changes"
    echo -e "  ${PURPLE}chore${NC}    🧹 Other changes\n"

    echo -e "${BOLD}EXAMPLES:${NC}"
    echo -e "  ${GRAY}# Basic commit${NC}"
    echo -e "  ${CYAN}cz${NC}"
    echo -e ""
    echo -e "  ${GRAY}# Search in specific directory${NC}"
    echo -e "  ${CYAN}cz --from${NC} ./src"
    echo -e ""
    echo -e "  ${GRAY}# Search with depth limit${NC}"
    echo -e "  ${CYAN}cz --depth${NC} 2\n"

    echo -e "${BOLD}TIPS:${NC}"
    echo -e "  ${YELLOW}•${NC} Use tab completion for options"
    echo -e "  ${YELLOW}•${NC} Breaking changes require description"
    echo -e "  ${YELLOW}•${NC} Scope is optional but recommended"
    echo -e "  ${YELLOW}•${NC} Keep commit messages concise\n"

    echo -e "${BOLD}${BLUE}═══════════════════════════════════════════════${NC}"
}

# Commit types for conventional commits
COMMIT_TYPES=(
    "feat: A new feature"
    "fix: A bug fix"
    "docs: Documentation only changes"
    "style: Changes that do not affect the meaning of the code"
    "refactor: A code change that neither fixes a bug nor adds a feature"
    "perf: A code change that improves performance"
    "test: Adding missing tests or correcting existing tests"
    "build: Changes that affect the build system or external dependencies"
    "ci: Changes to our CI configuration files and scripts"
    "chore: Other changes that don't modify src or test files"
)

# Function to handle conventional commits
handle_commit() {
    echo -e "${BLUE}🎯 Creating a conventional commit${NC}\n"
    
    # Use PS3 to customize the select prompt
    PS3=$'\n'"${GREEN}Select commit type (enter number):${NC} "
    
    select type in "${COMMIT_TYPES[@]}" "Quit"; do
        if [ "$type" = "Quit" ]; then
            echo -e "\n${YELLOW}Commit cancelled${NC}"
            return
        elif [ -n "$type" ]; then
            commit_type=${type%%:*}
            break
        else
            echo -e "${RED}Invalid selection. Please try again.${NC}"
        fi
    done

    echo -e "\n${GREEN}Selected type:${NC} ${PURPLE}${commit_type}${NC}"
    
    # Get commit message with the type already selected
    read -p $'\n'"${GREEN}Enter commit message (without type prefix):${NC} " message

    if [ -z "$message" ]; then
        echo -e "\n${RED}Empty commit message. Commit cancelled.${NC}"
        return
    fi

    # Optional scope
    read -p $'\n'"${GREEN}Enter commit scope (optional, press enter to skip):${NC} " scope
    
    # Construct commit message
    if [ -n "$scope" ]; then
        commit_msg="$commit_type($scope): $message"
    else
        commit_msg="$commit_type: $message"
    fi

    # Optional breaking change
    read -p $'\n'"${YELLOW}Add breaking change? (y/N):${NC} " breaking
    if [[ $breaking =~ ^[Yy]$ ]]; then
        read -p $'\n'"${YELLOW}Enter breaking change description:${NC} " breaking_msg
        if [ -n "$breaking_msg" ]; then
            commit_msg="$commit_msg

BREAKING CHANGE: $breaking_msg"
        fi
    fi

    # Show the final commit message and ask for confirmation
    echo -e "\n${CYAN}Final commit message:${NC}"
    echo -e "${BLUE}────────────────────${NC}"
    echo -e "${BOLD}${commit_msg}${NC}"
    echo -e "${BLUE}────────────────────${NC}"
    
    read -p $'\n'"${GREEN}Proceed with commit? (Y/n):${NC} " proceed
    if [[ $proceed =~ ^[Nn]$ ]]; then
        echo -e "\n${YELLOW}Commit cancelled${NC}"
        return
    fi

    echo -e "\n${CYAN}Committing changes...${NC}"
    git commit -m "$commit_msg"
    
    if [ $? -eq 0 ]; then
        echo -e "\n${GREEN}✔ Commit successful!${NC}"
    else
        echo -e "\n${RED}✘ Commit failed!${NC}"
    fi
}

search() {
    local dir="."
    local depth=""
    local ext=""
    local folder=""
    local string=""
    local max_size=""
    local last_used=""
    local exclude=""

    while [[ "$1" != "" ]]; do
        case $1 in
            --help) display_help; return ;;
            --from) shift; dir="$1" ;;
            --depth) shift; depth="-maxdepth $1" ;;
            --ext) shift; ext="$1" ;;
            --folder) folder="-type d" ;;
            --string) shift; string="$1" ;;
            --max-size) shift; max_size="-size -$1" ;;
            --last-used) last_used="-printf '%T@ %p\n' | sort -n | cut -d' ' -f2-" ;;
            --cz) handle_commit; return ;;
            *) echo -e "${RED}Unknown option: $1${NC}"; display_help; return 1 ;;
        esac
        shift
    done
}

# Add new alias
alias cz='search --cz'