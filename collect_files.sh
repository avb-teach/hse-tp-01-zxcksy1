#!/bin/bash

input_dir="$1"
output_dir="$2"

if [ $# -eq 4 ] && [ "$3" == "--max_depth" ] && [[ "$4" =~ ^[0-9]+$ ]]; then
    level_limit="$4"
    while IFS= read -r -d '' source_file; do
        relative_path="${source_file#$input_dir/}"
        
        IFS='/' path_segments=($relative_path)
        
        reconstructed_path=""
        current_depth=0
        for segment in "${path_segments[@]}"; do
            if [ $current_depth -lt $level_limit ]; then
                reconstructed_path="${reconstructed_path:+$reconstructed_path/}$segment"
                current_depth=$((current_depth + 1))
            else
                break
            fi
        done
        
        target_path="$output_dir/$reconstructed_path"
        mkdir -p "${target_path%/*}" 2>/dev/null
        cp "$source_file" "$target_path" 2>/dev/null
    done < <(find "$input_dir" -type f -print0)
else
    find "$input_dir" -type f -exec cp --parents {} "$output_dir" \; 2>/dev/null
fi
