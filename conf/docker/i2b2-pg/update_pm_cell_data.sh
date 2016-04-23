#!/bin/sh
echo ">>>Running postscript"
echo "delete from i2b2pm.pm_cell_data;" | psql -U postgres -d i2b2 
cat pm_access_insert_data.sql| sed "s/localhost:9090/$PUBLIC_IP/" |psql -U postgres "dbname=i2b2 options=--search_path=i2b2pm"  ;

