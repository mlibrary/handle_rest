#!/bin/sh

set -e

url="$1"
shift
timeout_seconds="${WAIT_FOR_HTTP_TIMEOUT:-300}"
elapsed=0
>&2 echo "${url}"


until [ $(curl -LI ${url} -o /dev/null -w '%{http_code}\n' -s) -eq 200 ]; do
  >&2 echo "${url} is unavailable - sleeping"
  sleep 1
  elapsed=$((elapsed + 1))
  if [ "${elapsed}" -ge "${timeout_seconds}" ]; then
    >&2 echo "Timed out waiting for ${url} after ${timeout_seconds} seconds"
    exit 1
  fi
done

>&2 echo "${url} is available - executing command"
>&2 echo "$@"

exec "$@"
