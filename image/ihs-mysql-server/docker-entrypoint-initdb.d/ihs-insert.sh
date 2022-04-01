#!/bin/sh
sed "s/PREFIX/${INDEPENDENT_HANDLE_SERVER_PREFIX}/g" /ihs/ihs-insert.sql | \
sed "s/PASSWORD/${MARIADB_PASSWORD}/g" | \
mysql --user $MARIADB_USER --password=$MARIADB_PASSWORD $MARIADB_DATABASE
