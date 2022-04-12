#!/bin/sh
set -e
sed -i "s/USER/${MARIADB_USER}/g" /ihs/config.dct
sed -i "s/PASSWORD/${MARIADB_PASSWORD}/g" /ihs/config.dct
sed -i "s/PREFIX/${INDEPENDENT_HANDLE_SERVER_PREFIX}/g" /ihs/config.dct
cat /ihs/config.dct
#while ! mysql --user=${MARIADB_USER} --password=${MARIADB_PASSWORD} --host=0.0.0.0; do
while ! mysql --user=${MARIADB_USER} --password=${MARIADB_PASSWORD} --host=mysql; do
  >&2 echo "Waiting for mysql database ... sleep 1"
  sleep 1
done
>&2 echo "Connected to database."
mysql --user=${MARIADB_USER} --password=${MARIADB_PASSWORD} --host=mysql --batch ${MARIADB_DATABASE} < create_tables.sql
sed -i "s/PASSWORD/${MARIADB_PASSWORD}/g" insert_into.sql
sed -i "s/PREFIX/${INDEPENDENT_HANDLE_SERVER_PREFIX}/g" insert_into.sql
mysql --user=${MARIADB_USER} --password=${MARIADB_PASSWORD} --host=mysql --batch ${MARIADB_DATABASE} < insert_into.sql
./bin/hdl-server /ihs
