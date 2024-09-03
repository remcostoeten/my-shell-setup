# dir_size_calculator.bash

# Function to calculate the size of a directory
dir_size() {
  if [ -z "$1" ]; then
    echo "Usage: dir_size <directory_path>"
    return 1
  fi

  if [ ! -d "$1" ]; then
    echo "Error: '$1' is not a valid directory."
    return 1
  fi

  du -sh "$1"
}
