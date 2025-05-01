

#!/bin/bash
input_dir="$1"
output_dir="$2"
max_depth=0  

if [ $# -eq 4 ] && [ "$3" == "--max_depth" ] && [[ "$4" =~ ^[0-9]+$ ]]; then
    max_depth="$4"
fi

mkdir -p "$output_dir"

find "$input_dir" -type f -print0 | while IFS= read -r -d $'\0' file; do
    rel_path="${file#$input_dir/}"
    depth=$(tr -cd '/' <<< "$rel_path" | wc -c)
    depth=$((depth + 1))

    if [ $depth -gt $max_depth ] && [ $max_depth -gt 0 ]; then
        overflow=$((depth - max_depth))
        rel_path=$(echo "$rel_path" | awk -F'/' -v o="$overflow" '{
            for (i=o+1; i<=NF; i++) printf "%s%s", $i, (i<NF?"/":"")
        }')
    fi

    dest="$output_dir/$rel_path"
    mkdir -p "$(dirname "$dest")"
    
    counter=1
    while [ -e "$dest" ]; do
        if [[ "$dest" =~ \.[^./]+$ ]]; then
            dest="${dest%.*}_${counter}.${dest##*.}"
        else
            dest="${dest}_${counter}"
        fi
        counter=$((counter + 1))
    done

    cp "$file" "$dest"
done
