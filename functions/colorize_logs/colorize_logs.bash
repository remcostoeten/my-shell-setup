colorize_logs() {
  grep --color=always -E "ERROR|WARN|INFO|DEBUG" "$1" | less -R
}

alias log=colorize_logs

# README
# This script is used to colorize log files based on the log level. It highlights lines containing "ERROR", "WARN", "INFO", and "DEBUG" in different colors.
# 
# Usage:
#   log <log_file_path>
# 
# Example:
#   log /path/to/your/log/file.log
# 
# This script is particularly useful for quickly identifying important log messages, such as errors or warnings, in a large log file.


# log log.log
