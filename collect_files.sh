#!/bin/bash

input_dir="$1"
output_dir="$2"
depth_limit=""

if [[ $# -ge 4 && "$3" == "--max_depth" && "$4" =~ ^[0-9]+$ ]]; then
    depth_limit="$4"
fi

if [[ -n "$depth_limit" ]]; then
    while IFS= read -r -d '' file_path; do
        relative_path="${file_path#$input_dir/}"
        
        dir_level=$(echo "$relative_path" | awk -F'/' '{print NF}')
        
        if (( dir_level > depth_limit )); then
            trim_count=$((dir_level - depth_limit))
            adjusted_path=$(echo "$relative_path" | awk -F'/' -v t="$trim_count" '{
                for (i=t+1; i<=NF; i++) printf "%s%s", $i, (i<NF?"/":"")
            }')
        else
            adjusted_path="$relative_path"
        fi
        
        target_path="$output_dir/$adjusted_path"
        mkdir -p "$(dirname "$target_path")"
        cp -f "$file_path" "$target_path"
    done < <(find "$input_dir" -type f -print0)
else
    find "$input_dir" -type f -exec cp -f {} "$output_dir" \;
fi
