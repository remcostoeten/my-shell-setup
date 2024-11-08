#!/bin/bash
# Copy utility functions for zsh

# Copy contents of a file to clipboard
function fnc_copy_file_contents() {
    if [ -z "$1" ]; then
        echo "Error: Please provide a file path"
        return 1
    fi
    
    if [ ! -f "$1" ]; then
        echo "Error: File '$1' does not exist"
        return 1
    fi
    
    command cat "$1" | xclip -selection clipboard
    echo "Contents of '$1' copied to clipboard"
}

# Copy current working directory to clipboard
function fnc_copy_pwd() {
    pwd | xclip -selection clipboard
    echo "Current directory path copied to clipboard"
}

# Copy filename of given path to clipboard
function fnc_copy_filename() {
    if [ -z "$1" ]; then
        echo "Error: Please provide a file path"
        return 1
    fi
    
    basename "$1" | xclip -selection clipboard
    echo "Filename '$(basename "$1")' copied to clipboard"
}

# Copy full path of a file to clipboard
function fnc_copy_filepath() {
    if [ -z "$1" ]; then
        echo "Error: Please provide a file path"
        return 1
    fi
    
    readlink -f "$1" | xclip -selection clipboard
    echo "Full path '$(readlink -f "$1")' copied to clipboard"
}

# Aliases
alias copy='fnc_copy_file_contents'
alias copypwd='fnc_copy_pwd'
alias copyname='fnc_copy_filename'
alias copypath='fnc_copy_filepath'