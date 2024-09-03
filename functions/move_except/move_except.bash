a# Wrapper function for mv that supports exclusion of files
mv_except() {
  # Check if '--ex' is used
  if [[ "$*" == *"--ex"* ]]; then
    # Extract the pattern and target directory
    local pattern=$1
    local target_directory=$2
    shift 2

    # Ensure '--ex' is the next argument
    if [ "$1" != "--ex" ]; then
      echo "Usage: mv <pattern> <target_directory> --ex <file1> [file2 ...]"
      return 1
    fi

    shift  # Remove '--ex' from the arguments

    # Create an array of files to exclude
    local exclude_files=("$@")

    # Use a loop to move all files matching the pattern, excluding the specified ones
    for file in $pattern; do
      if [[ ! " ${exclude_files[@]} " =~ " ${file} " ]]; then
        mv "$file" "$target_directory"
      fi
    done
  else
    # If '--ex' is not used, perform a regular move
    command mv "$@"
  fi
}

# Create an alias for the mv command to use mv_except
alias mv=mv_except

 
