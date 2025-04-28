#!/bin/bash
input_dir=$1
output_dir=$2
max_depth=""

for meow in "$@"; do
    if [[ $meow == --max_depth=* ]]; then
        max_depth="${meow#*=}"
    fi
done

if [ -n "$max_depth" ]; then
    find "$input_dir" -maxdepth "$max_depth" -type f -exec cp {} "$output_dir" \;
else
    find "$input_dir" -type f -exec cp {} "$output_dir" \;
fi

