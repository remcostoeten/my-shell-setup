# Source all .sh files in the functions directory
if [ -d "$DOTFILES_PATH/modules/functions" ]; then
  for func_file in "$DOTFILES_PATH"/modules/functions/*.sh; do
    if [ -f "$func_file" ]; then
      source "$func_file"
    fi
  done
  unset func_file # Clean up loop variable
fi