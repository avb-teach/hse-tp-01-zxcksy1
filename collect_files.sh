#!/bin/bash
input_dir=$1
output_dir=$2
max_depth=""

for my in "$@"; do
    if [[ $my == --max_depth ]]; then
        max_depth=$2
        shift 2
    fi
done

find "$input_dir" -type f ${max_depth:+ -maxdepth "$max_depth"} -exec cp --parents {} "$output_dir" \;
#find "$input_dir" -type f -exec cp {} "$output_dir" \;
