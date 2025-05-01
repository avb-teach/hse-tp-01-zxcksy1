'''#!/bin/bash
input_dir=$1
output_dir=$2
max_depth=""


find "$input_dir" -type f -exec cp {} "$output_dir" \;'''

#!/bin/bash

input_dir="$1"
output_dir="$2"
max_depth=0

[[ $# -eq 4 && "$3" == "--max_depth" && "$4" =~ ^[0-9]+$ ]] && max_depth="$4"

mkdir -p "$output_dir"

unique_name() {
    local path="$1" counter=1
    while [ -e "$path" ]; do
        [[ "$path" =~ \.[^./]+$ ]] && path="${path%.*}_${counter}.${path##*.}" || path="${path}_${counter}"
        ((counter++))
    done
    echo "$path"
}

if [[ $max_depth -eq 0 ]]; then
    find "$input_dir" -type f -exec sh -c '
        for file; do
            cp "$file" "$(unique_name "$0/$(basename "$file")")"
        done
    ' "$output_dir" {} +
    exit
fi

find "$input_dir" -type f -exec sh -c '
    for file; do
        rel_path="${file#$3/}"
        depth=$(tr -cd / <<< "$rel_path" | wc -c)
        ((depth++))
        ((depth > $1)) && rel_path=$(echo "$rel_path" | awk -F/ -v o=$((depth-$1)) "{for(i=o+1;i<=NF;i++)printf \$i (i<NF?\"/\":\"\")}")
        dest="$2/$rel_path"
        mkdir -p "$(dirname "$dest")"
        cp "$file" "$(unique_name "$dest")"
    done
' "$max_depth" "$output_dir" "$input_dir" {} +
