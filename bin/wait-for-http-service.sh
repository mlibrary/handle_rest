#!/bin/sh

set -e

url="$1"
shift
>&2 echo "${url}"


until [ $(curl -LI ${url} -o /dev/null -w '%{http_code}\n' -s) -eq 200 ]; do
  >&2 echo "${url} is unavailable - sleeping"
  sleep 1
done

>&2 echo "${url} is available - executing command"
>&2 echo "$@"

exec "$@"
