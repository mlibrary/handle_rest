#!/bin/sh

pwd=$(pwd)
echo "pwd: $pwd"
echo "script: $0"
echo "script dirname: $(dirname $0)"
echo "file: $1"
echo "file dirname: $(dirname $1)"

file_path="$1"
echo "file_path: $file_path"
file_name="${file_path##*/}"
echo "file_name: $file_name"
file_extension="${file_name##*.}"
echo "file_extension: $file_extension"
file_base="${file_name%.*}"
echo "file_base: $file"

export YML_MY_APP="testbed"
echo "app: $YML_MY_APP"
export YML_MY_NAME=$file_base
echo "name: $YML_MY_NAME"
export GITHUB_PACKAGES_READ=`echo "${GITHUB_USER}:${GITHUB_READ_PACKAGES_TOKEN}" | base64`
echo "github_packages_read: $GITHUB_PACKAGES_READ"

export YML_MY_MARIADB_ROOT_PASSWORD=password
echo "mariadb root password: $YML_MY_MARIADB_ROOT_PASSWORD"
export YML_MY_MARIADB_USER=ihs
echo "mariadb user: $YML_MY_MARIADB_USER"
export YML_MY_MARIADB_PASSWORD=password
echo "mariadb password: $YML_MY_MARIADB_PASSWORD"
export YML_MY_MARIADB_DATABASE=ihs
echo "mariadb database: $YML_MY_MARIADB_DATABASE"

export YML_MY_INDEPENDENT_HANDLE_SERVER_DEPLOY=ihs
echo "IHS deploy: $YML_MY_INDEPENDENT_HANDLE_SERVER_DEPLOY"
export YML_MY_INDEPENDENT_HANDLE_SERVER_PREFIX=IHS
echo "IHS prefex: $YML_MY_INDEPENDENT_HANDLE_SERVER_PREFIX"
export YML_MY_INDEPENDENT_HANDLE_SERVER_ADMIN=IHS
echo "IHS admin: $YML_MY_INDEPENDENT_HANDLE_SERVER_ADMIN"
export YML_MY_INDEPENDENT_HANDLE_SERVER_PASSWORD=IHS
echo "IHS password: $YML_MY_INDEPENDENT_HANDLE_SERVER_PASSWORD"

envsubst < $1.envsubst > $1
