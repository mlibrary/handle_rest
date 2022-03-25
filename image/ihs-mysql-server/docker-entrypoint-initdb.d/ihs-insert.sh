#!/bin/sh
sed "s/PREFIX/${INDEPENDENT_HANDLE_SERVER_PREFIX}/g" /ihs/ihs-insert.sql | \
sed "s/ADMIN/${INDEPENDENT_HANDLE_SERVER_ADMIN}/g" | \
sed "s/PASSWORD/${INDEPENDENT_HANDLE_SERVER_PASSWORD}/g" | \
mysql --user $MARIADB_USER --password=$MARIADB_PASSWORD $MARIADB_DATABASE