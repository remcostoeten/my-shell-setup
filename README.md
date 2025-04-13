# Dotfiles

This repository contains configuration files (dotfiles) for various tools and applications. Files inside folders with the `.symlink` suffix are intended to be symlinked to their respective locations on your system.

---

## Naming Convention

Folders ending with `.symlink` contain files that need to be symlinked. For example:

- `hammerspoon.symlink/init.lua` → `~/.hammerspoon/init.lua`
- `vim.symlink/.vimrc` → `~/.vimrc`
- `zsh.symlink/.zshrc` → `~/.zshrc`

---

## Project structure

I try to maintain a a certain structure in this architecture

`/core/` is where all the injectors live which are responsible for injecting a certain module(s) into the main config. It also contains other required setup configuration.

`/programs` are custom CLI tools or other helper utilities.

To be continued..
