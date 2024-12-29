#!/bin/bash

function search() {
    if [ -z "$1" ]; then
        echo "Usage: search <pattern>"
        return 1
    fi
    grep -r "$1" .
}
