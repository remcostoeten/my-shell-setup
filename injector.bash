#!/bin/bash

source './aliases/alias_injector.sh'

base_dir="$(dirname "${BASH_SOURCE[0]}")"
function_dir="$base_dir/functions"
library_dir="$base_dir/libraries"
types=("functions" "library")

declare -A sourced_counts
declare -A failed_counts

source_files() {
  local dir="$1"
  local type="$2"
  while IFS= read -r -d '' file; do
    if source "$file" 2>/dev/null; then
      ((sourced_counts[$type]++))
    else
      echo "Failed to source $type: $(basename "$file")"
      ((failed_counts[$type]++))
    fi
  done < <(find "$dir" -type f -name "*.bash" -print0)
}

source_files "$function_dir" "functions"
source_files "$library_dir" "library"

# Source the nvidia_fan_control function
source "$function_dir/nvidia_fan_control/nvidia_fan_control.bash"

total_sourced=0
total_failed=0

for type in "${types[@]}"; do
  sourced=${sourced_counts[$type]:-0}
  failed=${failed_counts[$type]:-0}
  echo "Sourced $sourced $type. Failed to source $failed $type."
  ((total_sourced += sourced))
  ((total_failed += failed))
done

echo "Total: Sourced $total_sourced items. Failed to source $total_failed items."
