#!/bin/bash

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
    echo "Select commit type:"
    select type in "${COMMIT_TYPES[@]}"; do
        if [ -n "$type" ]; then
            commit_type=${type%%:*}
            break
        fi
    done

    read -p "Enter commit scope (optional): " scope
    read -p "Enter commit message: " message

    if [ -n "$scope" ]; then
        commit_msg="$commit_type($scope): $message"
    else
        commit_msg="$commit_type: $message"
    fi

    read -p "Add breaking change? (y/N): " breaking
    if [[ $breaking =~ ^[Yy]$ ]]; then
        read -p "Enter breaking change description: " breaking_msg
        commit_msg="$commit_msg

BREAKING CHANGE: $breaking_msg"
    fi

    git commit -m "$commit_msg"
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
            --from) shift; dir="$1" ;;
            --depth) shift; depth="-maxdepth $1" ;;
            --ext) shift; ext="$1" ;;
            --folder) folder="-type d" ;;
            --string) shift; string="$1" ;;
            --max-size) shift; max_size="-size -$1" ;;
            --last-used) last_used="-printf '%T@ %p\n' | sort -n | cut -d' ' -f2-" ;;
            --cz) handle_commit; return ;;
            *) echo "Unknown option: $1"; display_search_help; return 1 ;;
        esac
        shift
    done
    # ... rest of the search function
}

# Add new alias
alias cz='git add .  ;search --cz'