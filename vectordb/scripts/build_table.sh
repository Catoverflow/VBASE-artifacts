#!/bin/bash

docker exec -it vectordb_cyq psql -U vectordb -f /vectordb/scripts/create_table.sql
