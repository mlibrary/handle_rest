#!/bin/sh

if [ $# -eq 0 ]; then
 echo "usage: $0 image_directory"
 exit 1
fi

cd "$1" || exit

IMAGE_NAME=`pwd | awk -F/ '{ print $NF }'`
IMAGE_NAME_VERSION="${IMAGE_NAME}:latest"
docker build -t ${IMAGE_NAME_VERSION} .
