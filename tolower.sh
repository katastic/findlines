#!/bin/bash
for file in *; do
  if [ -f "$file" ]; then
    new_file=$(echo "$file" | tr '[:upper:]' '[:lower:]')
    if [ "$file" != "$new_file" ]; then
      mv "$file" "$new_file"
      echo "Renamed '$file' to '$new_file'"
    fi
  fi
done
