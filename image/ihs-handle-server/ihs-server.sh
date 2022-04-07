#!/bin/sh
set -e
sed -i "s/USER/${MARIADB_USER}/g" /ihs/config.dct
sed -i "s/PASSWORD/${MARIADB_PASSWORD}/g" /ihs/config.dct
sed -i "s/PREFIX/${INDEPENDENT_HANDLE_SERVER_PREFIX}/g" /ihs/config.dct
cat /ihs/config.dct
#while ! mysqladmin ping --user=${MARIADB_USER} --password=${MARIADB_PASSWORD} --host=mysql; do sleep 1; done
while ! mysql --user=${MARIADB_USER} --password=${MARIADB_PASSWORD} --host=0.0.0.0; do
  sleep 1
done
./bin/hdl-server /ihs
