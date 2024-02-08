#!/bin/bash

# Define the base directory where the current data resides
directory='/krummellab/data1/zachsten/personal/MIBI_data_files/zach_test_sets/'
# Path to the CSV file
csv_file="/krummellab/data1/zachsten/personal/MIBI_data_files/zach_test_sets/file_annotate.csv"
# Path to the new directory where renamed folders will be moved
new_directory="age_data_subset_organized"
# Create the new directory if it does not exist
mkdir -p "$new_directory"

# Read each line of the CSV
while IFS=, read -r parent_dir fov new_name
do
    # Extract the number from the FOV value (assuming the format is FOV<number>)
    fov_number=$(echo "$fov" | sed 's/FOV//')
    # Construct the full path to the parent directory
    full_parent_path="${directory}${parent_dir}"
    # Construct the pattern to match the folder
    pattern="fov-${fov_number}-scan-1"
    # Find matching folder
    current_path=$(find "$full_parent_path" -type d -name "$pattern" -print -quit)

    if [ -n "$current_path" ]; then
        # New path with the new name
        new_path="$full_parent_path/$new_name"

        # Rename and move the directory
        mv "$current_path" "$new_path"
        mv "$new_path" "$new_directory/"
        echo "Moved $current_path to $new_directory/$new_name"
    else
        echo "No directory matching $pattern found in $full_parent_path"
    fi
done < "$csv_file"

# Loop through each item in the directory
for dir in "$new_directory"/*; do
    # Check if it's a directory
    if [ -d "$dir" ]; then
        # Remove carriage return characters and rename
        new_dir=$(echo "$dir" | tr -d '\r')
        if [ "$dir" != "$new_dir" ]; then
            mv "$dir" "$new_dir"
        fi
    fi
done