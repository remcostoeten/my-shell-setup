# Generic function to create command aliases
create_command_alias() {
  local alias_name="$1"
  local command="$2"
  local help_text="$3"

  if [ -z "$alias_name" ] || [ -z "$command" ]; then
    echo -e "\e[31mUsage: create_command_alias <alias_name> <command> [help_text]\e[0m"
    return 1
  fi

  alias "$alias_name"="$command"

  if [ ! -z "$help_text" ]; then
    COMMAND_HELP[$alias_name]="$help_text"
  fi
}

# create help array
COMMAND_HELP=()

# Function to display help for all aliases
show_all_aliases_help() {
  echo -e "\e[32mAvailable Command Aliases:\e[0m"
  for alias_name in "${!COMMAND_HELP[@]}"; do
    echo -e "  \e[33m$alias_name\e[0m: ${COMMAND_HELP[$alias_name]}"
  done
}

# Helper to show a specific alias help message.
show_alias_help() {
  local alias_name="$1"
  if [ -z "$alias_name" ]; then
    echo -e "\e[31mUsage: alias_help <alias_name>\e[0m"
    return 1
  fi
  if [ -z "${COMMAND_HELP[$alias_name]}" ]; then
    echo -e "\e[31mNo help available for alias: $alias_name\e[0m"
    return 1
  fi
  echo -e "\e[32mHelp for \e[33m$alias_name\e[32m:\e[0m ${COMMAND_HELP[$alias_name]}"
}

# Function to display an interactive menu
show_interactive_menu() {
  echo -e "\e[34m\nInteractive Alias Helper Menu:\e[0m"
  select opt in "List All Aliases" "Help for Specific Alias" "Exit"; do
    case $opt in
    "List All Aliases")
      show_all_aliases_help
      break
      ;;
    "Help for Specific Alias")
      read -p "Enter alias name: " alias_name
      show_alias_help "$alias_name"
      break
      ;;
    "Exit")
      break
      ;;
    *) echo -e "\e[31mInvalid option\e[0m" ;;
    esac
  done
}

# create aliases for cd .. , cd ... , cd .... etc.

create_command_alias "cd.." "cd .." "Navigate up one directory"
create_command_alias "cd..." "cd ../.." "Navigate up two directories"
create_command_alias "cd...." "cd ../../.." "Navigate up three directories"
create_command_alias "cd....." "cd ../../../.." "Navigate up four directories"
create_command_alias "cd......" "cd ../../../../.." "Navigate up five directories"
create_command_alias "la" "ls -la" "List all files and directories in detail"
create_command_alias ".." "cd .." "Navigate up one directory (shorthand)"
create_command_alias "help_aliases" "show_all_aliases_help" "Show help for available aliases"

# Show aliases help as an example
# alias_help cd..

# Add a menu entry point
show_interactive_menu
