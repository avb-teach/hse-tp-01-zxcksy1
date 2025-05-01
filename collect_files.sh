'''#!/bin/bash
input_dir=$1
output_dir=$2
max_depth=""


find "$input_dir" -type f -exec cp {} "$output_dir" \;'''

#!/bin/bash
if [[ "$1" == "--max_depth" ]]; then
    max_depth="$2"
    input_dir="$3"
    output_dir="$4"
    find "$input_dir" -mindepth 1 -maxdepth "$max_depth" -type f -exec cp {} "$output_dir" \;
else
    input_dir="$1"
    output_dir="$2"
    find "$input_dir" -type f -exec cp {} "$output_dir" \;
fi


