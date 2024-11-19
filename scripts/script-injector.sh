#!/bin/bash

# Define the path to the search_wrapper.sh script
SEARCH_WRAPPER_PATH="/path/to/search_wrapper.sh"
:Q

# Source the search_wrapper.sh script
if [ -f "$SEARCH_WRAPPER_PATH" ]; then
  source "$SEARCH_WRAPPER_PATH"
else
  echo "Error: $SEARCH_WRAPPER_PATH not found."
fi

