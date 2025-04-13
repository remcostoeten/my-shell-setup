# Dotfiles

This repository contains configuration files (dotfiles) for various tools and applications. Files inside folders with the `.symlink` suffix are intended to be symlinked to their respective locations on your system.

---

## Naming Convention

Folders ending with `.symlink` contain files that need to be symlinked. For example:
- `hammerspoon.symlink/init.lua` → `~/.hammerspoon/init.lua`
- `vim.symlink/.vimrc` → `~/.vimrc`
- `zsh.symlink/.zshrc` → `~/.zshrc`

---

## Setup Instructions

Follow these steps to set up your dotfiles on a new machine:

### 1. Clone the Repository
Clone this repository into your system:
