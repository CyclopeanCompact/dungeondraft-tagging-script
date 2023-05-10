#!/bin/bash

# Navigate to [Directory], the directory where the script is located
cd "$(dirname "$0")"

echo "Beginning tag process. This might take a minute or two, please wait."

# Create an empty JSON data structure
json_data='{ "tags": {}, "sets": {} }'

# Iterate through each subdirectory in [Directory]/textures/objects
while IFS= read -r -d '' subdir; do
  # Get the name of the current subdirectory
  tag_name=$(basename "$subdir")

  echo "Scanning $tag_name."

  # Check if there's already a tag with the same name
  if grep -q "\"$tag_name\":" <<< "$json_data"; then
    continue
  fi

  # Add a new tag array for the current subdirectory
  json_data=$(jq --arg tag "$tag_name" '.tags[$tag] = []' <<< "$json_data")
done < <(find textures/objects/* -type d -print0)

# Iterate through each PNG or WEBP image file in [Directory]/textures/objects
while IFS= read -r -d '' imgfile; do

  echo "Sorting ${imgfile##*/}."

  # Get the full directory path for the current image file, relative to [Directory]
  tag_path=$(dirname "$imgfile")

  # Get the truncated directory path for the current image file, relative to [Directory]/textures/objects
  truncated_tag_path=${tag_path#textures/objects/}

  # Split the path into an array of directories
  IFS='/' read -ra tag_array <<< "$truncated_tag_path"

  # Iterate through each directory in the path and add the image file to its corresponding tag array
  for tag_name in "${tag_array[@]}"; do

    # Add the current image file to the tag array
    json_data=$(jq --arg tag "$tag_name" --arg file "$tag_path/${imgfile##*/}" '.tags[$tag] += [$file]' <<< "$json_data")
  done
done < <(find textures/objects -type f \( -name "*.png" -o -name "*.webp" \) -print0)


# Sort the "tags" object arrays in descending order
json_data=$(jq --arg dirname "$(basename "$(pwd)")" '.sets[$dirname] = []' <<< "$json_data")

# Tell the user what's happening.
echo "Creating set object for tag names."

# # Create a new SETS array for this directory
json_data=$(jq --arg dirname "$(basename "$(pwd)")" '.sets[$dirname] = []' <<< "$json_data")

# Iterate through each tag and add it to the SETS array
tag_names=$(jq -r '.tags | keys | .[]' <<< "$json_data" | sort)
while IFS= read -r tag_name; do
  json_data=$(jq --arg tag "$tag_name" --arg dirname "$(basename "$(pwd)")" '.sets[$dirname] += [$tag]' <<< "$json_data")
done < <(echo "$tag_names")

# Print the final JSON data structure to a file
echo "$json_data" | jq -M '.' > data/default.dungeondraft_tags

# Notify the user that the process is finished
echo "Tagging complete. It's safe to exit."

exit
