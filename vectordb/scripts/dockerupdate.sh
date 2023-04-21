#!/bin/bash

#remake
docker exec -it -u 0 vectordb_cyq bash -c "cd /vectordb/build && cmake .. && make -j 8 && make install"

#restart
#docker exec -it vectordb_cyq bash -c "/u01/app/postgres/product/13.4/bin/pg_ctl -D /u02/pgdata/13 stop -m fast"
#sleep 10
#docker start vectordb_cyq