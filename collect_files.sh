#!/bin/bash
input_dir=$1
output_dir=$2
max_depth=1
for im in "$@"; do
  if [[ $im == --max_depth=* ]]; then
    max_depth="${im#*=}"
  fi
done
find "$input_dir" -maxdepth "$max_depth" -type f -exec cp {} "$output_dir" \;
