## ZSH Configuration Help Script

![zsh](https://github.com/user-attachments/assets/57f804c2-dd43-4f56-92f9-d55d599f4b7a)

This script provides a comprehensive help system for your ZSH configuration. It includes functions for displaying general help, task help, search help, category-specific help, listing all commands, and searching for specific commands.

### Features

- Colorful output for better readability
- Multiple help categories
- Search functionality for commands and aliases
- Easy to extend and customize

### Installation

Save the script as `_zsh-help-menu.sh` in your ZSH setup directory (e.g., `~/projects/zsh-setup/initialize/`).

Make the script executable:

```bash
chmod +x ~/projects/zsh-setup/initialize/_zsh-help-menu.sh
```

Source the script in your `.zshrc` file:

```bash
source ~/projects/zsh-setup/initialize/_zsh-help-menu.sh
```

### Usage

After installation, you can use the `zshhelp` command to access the help menu:

```bash
zshhelp
```

For specific help topics:

```bash
zshhelp --category git
zshhelp search
zshhelp task
```

### Script Overview

Here's a brief overview of the main components of the script:

```bash
#!/usr/bin/env zsh

# Color definitions using tput
if [ -t 1 ]; then
  COLOR_RESET=$(tput sgr0)
  COLOR_BOLD=$(tput bold)
  # ... (other color definitions)
fi

# Function to display general help menu
display_help_menu() {
  echo "${COLOR_BOLD}${COLOR_BLUE}╔════════════════════════════════════════════════════════════════╗${COLOR_RESET}"
  echo "${COLOR_BOLD}${COLOR_BLUE}║                   ZSH Configuration Help                       ║${COLOR_RESET}"
  echo "${COLOR_BOLD}${COLOR_BLUE}╚════════════════════════════════════════════════════════════════╝${COLOR_RESET}"
  # ... (help menu content)
}

# Main zsh_help function
zsh_help() {
  case $1 in
    --category)
      display_category_help $2
      ;;
    # ... (other cases)
  esac
}

# Define the zshhelp function
zshhelp() {
  if [ $# -eq 0 ]; then
    zsh_help --help
  else
    zsh_help "$@"
  fi
}
```

### Customization

You can easily extend this script by adding new categories or modifying existing ones. Simply update the `display_help_menu()` function and add corresponding case statements in the `zsh_help()` function.

### Contributing

Feel free to fork this repository and submit pull requests for any enhancements or bug fixes.

### License

This project is open source and available under the MIT License.

### Author

Created by Remco Stoeten (@remcostoeten)  
Last updated: 2024-07-28

For more information, visit [https://github.com/remcostoeten/my-shell-setup](https://github.com/remcostoeten/my-shell-setup)
