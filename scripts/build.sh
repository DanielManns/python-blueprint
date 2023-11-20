#!/bin/bash

script_dir=$(dirname $(realpath -s $0))
parent_dir=$(dirname $script_dir)
project_name=$(basename $(dirname $script_dir))

target=${1:-"base"}
image_name=${2:-"$project_name:base"}

( \
    cd $(dirname "$0")/../; \
    DOCKER_BUILDKIT=1 docker build \
        --target $target \
        --tag $image_name \
        --file Dockerfile \
        --progress=plain \
        . \
)