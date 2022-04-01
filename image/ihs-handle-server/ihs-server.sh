#!/bin/sh
echo +x # echo on
sed -i "s/USER/${MARIADB_USER}/g" /ihs/config.dct
sed -i "s/PASSWORD/${MARIADB_PASSWORD}/g" /ihs/config.dct
sed -i "s/PREFIX/${INDEPENDENT_HANDLE_SERVER_PREFIX}/g" /ihs/config.dct
./bin/hdl-server /ihs
