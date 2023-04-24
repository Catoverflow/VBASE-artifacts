#!/bin/bash

docker run --name=vectordb_cyq --security-opt seccomp=../seccomp-perf.json -e PGPASSWORD=vectordb -e PGUSERNAME=vectordb -e PGDATABASE=vectordb -v `pwd`/..:/vectordb -v /dev/shm/pg:/u02  vectordb_cyq &

