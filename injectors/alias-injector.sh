# Define the directory containing the alias files
# Note: Double-check if the directory name is 'aliasses' or 'aliases' (standard spelling)
alias_dir="$DOTFILES_PATH/modules/aliasses"

# Check if the directory actually exists
if [ -d "$alias_dir" ]; then
  # Loop through all entries in the directory
  # Using "$alias_dir"/* ensures files with spaces are handled correctly
  for file in "$alias_dir"/*; do
      # Check if the entry is a regular file (not a directory, symlink, etc.)
      if [ -f "$file" ]; then
          # Source the file into the current shell environment
          # Using . is a shorthand and slightly more portable version of 'source'
          . "$file"
          # You could also use: source "$file"

          # Optional: uncomment the next line for debugging to see which files are sourced
          # echo "Sourced: $file"
      fi
  done
else
  # Optional: Print a warning if the directory doesn't exist
  echo "Warning: Alias directory not found: $alias_dir" >&2
fi

# Clean up the variable if you don't need it anymore
unset alias_dir