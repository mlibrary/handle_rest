#!/bin/sh

if [ $# -eq 0 ]; then
 echo "usage: $0 image_directory"
 exit 1
fi

cd "$1" || exit

IMAGE_NAME=`pwd | awk -F/ '{ print $NF }'`
IMAGE_NAME_VERSION="${IMAGE_NAME}:latest"
GITHUB_USER_IMAGE_NAME_VERSION="ghcr.io/${GITHUB_USER}/${IMAGE_NAME_VERSION}"
docker tag $IMAGE_NAME_VERSION $GITHUB_USER_IMAGE_NAME_VERSION
docker login ghcr.io --username $GITHUB_USER --password $GITHUB_WRITE_PACKAGES_TOKEN
docker push $GITHUB_USER_IMAGE_NAME_VERSION
