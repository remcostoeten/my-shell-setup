# Move Except Script

This script is a wrapper function for the `mv` command that allows for the exclusion of specific files or patterns during a move operation. It enhances the traditional `mv` command by providing an `--ex` option to specify files or patterns to exclude from the move operation.

## Usage

To use the `mv_except` function, call it with the following syntax:

* `mv_except <pattern> <target_directory> --ex <file1> [file2 ...]`

Where:
* `<pattern>` is the pattern or file name to move.
* `<target_directory>` is the directory where the files will be moved.
* `--ex` is the option to specify files to exclude.
* `<file1> [file2 ...]` are the files or patterns to exclude from the move operation.

For example:
* `mv_except *.txt /new/directory --ex file1.txt file2.txt` moves all `.txt` files to `/new/directory`, excluding `file1.txt` and `file2.txt`.
* `mv_except * /new/directory --ex file1.txt file2.txt` moves all files to `/new/directory`, excluding `file1.txt` and `file2.txt`.

## Features

* Supports exclusion of specific files or patterns during a move operation.
* Allows for the use of wildcards in the pattern to move multiple files at once.
* Provides a convenient way to move files while excluding certain files or patterns.

## Installation

To use this script, save it to a file (e.g., `move_except.bash`), make the file executable with `chmod +x move_except.bash`, and then add it to your system's PATH. You can then call the script from anywhere in your terminal.

## Customization

The script can be customized by modifying the function to suit specific needs or requirements.
