#!/bin/bash

target=base_builder
temp_image_name="lock_poetry:temp"
temp_container_name="lock_poetry"

# Remove container if it still exists
docker rm $temp_container_name 2> /dev/null

# Let the script fail on first error
set -e

# Get the abolute paths of this script and the parent folder
script_dir=$(dirname $(realpath -s $0))
parent_dir=$(dirname $script_dir)

# Build the poetry stage
$script_dir/build.sh $target $temp_image_name;

# Update the lock file
docker run --name $temp_container_name -it $temp_image_name poetry lock --no-update

# Copy the updated lock file
poetry_lock_path=$parent_dir/poetry.lock
docker cp $temp_container_name:/src/poetry.lock $poetry_lock_path

# Remove container and image
docker rm $temp_container_name
docker rmi $temp_image_name
