#!/bin/bash

input_dir="$1"
output_dir="$2"

if [ $# -eq 4 ] && [ "$3" == "--max_depth" ] && [[ "$4" =~ ^[0-9]+$ ]]; then
    max_depth="$4"

    while IFS= read -r -d '' file; do
        rel_path="${file#$input_dir}"
        rel_path="${rel_path#/}"
        
        IFS='/' read -ra path_parts <<< "$rel_path"
        new_path=""
        part_count=0
        for part in "${path_parts[@]}"; do
            if [ $part_count -lt $max_depth ]; then
                new_path="${new_path:+$new_path/}$part"
                part_count=$((part_count + 1))
            fi
        done
        
        mkdir -p "$output_dir/${new_path%/*}" 2>/dev/null
        cp "$file" "$output_dir/$new_path" 2>/dev/null
    done < <(find "$input_dir" -type f -print0)
else
    find "$input_dir" -type f -exec cp {} "$output_dir" \; 2>/dev/null
fi
