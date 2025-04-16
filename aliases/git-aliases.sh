#!/bin/bash

# File: git-aliases.sh
# Created: $(date +%Y-%m-%d)
# Description: Common Git aliases for improved workflow

# Status
alias gs='git status'
alias gss='git status -s'

# Branch
alias gb='git branch'
alias gba='git branch -a'
alias gbd='git branch -d'

# Checkout
alias gco='git checkout'
alias gcb='git checkout -b'

# Add
alias ga='git add'
alias gaa='git add --all'
alias gap='git add -p'

# Commit
alias gc='git commit'
alias gcm='git commit -m'
alias gca='git commit --amend'

# Push/Pull
alias gp='git push'
alias gpf='git push --force-with-lease'
alias gl='git pull'
alias gpr='git pull --rebase'

# Log
alias glog='git log --oneline --decorate --graph'
alias gloga='git log --oneline --decorate --graph --all'

# Diff
alias gd='git diff'
alias gds='git diff --staged'

# Last updated: $(date +%Y-%m-%d) 