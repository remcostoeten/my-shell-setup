#!/bin/bash
# File: ls.sh
# Created: $(date +"%Y-%m-%d")
# Description: Enhanced ls aliases using eza

# Basic exa aliases
alias ls='eza --group-directories-first'
alias l='eza -l --group-directories-first'
alias ll='eza -la --group-directories-first'
alias lt='eza --tree --level=2 --group-directories-first'
alias llt='eza -la --tree --level=2 --group-directories-first'

# Detailed listing
alias la='eza -la --group-directories-first'
alias lg='eza -la --git --group-directories-first'
alias lh='eza -la --git --header --group-directories-first'

# Sorting
alias lm='eza -la --sort=modified --group-directories-first'
alias lsize='eza -la --sort=size --group-directories-first'
alias lext='eza -la --sort=extension --group-directories-first'

# Tree views
alias ltree='eza --tree --group-directories-first'
alias lt2='eza --tree --level=2 --group-directories-first'
alias lt3='eza --tree --level=3 --group-directories-first'

# Git integration
alias lgit='eza -la --git --git-ignore --group-directories-first'
alias lgh='eza -la --git --header --git-ignore --group-directories-first'

# Icons (if your terminal supports it)
alias li='eza -la --icons --group-directories-first'
alias lit='eza --tree --icons --group-directories-first' 