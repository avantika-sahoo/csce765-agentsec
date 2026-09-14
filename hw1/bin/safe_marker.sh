#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 course-marker" >&2
    exit 1
fi

marker="$1"
printf '%s\n' "$marker" > "$HOME/csce765-agentsec/hw1/markers/marker.txt"
