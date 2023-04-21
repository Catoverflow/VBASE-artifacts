#!/bin/bash
CWD=$(pwd)
docker run --name=vectordb_cyq --security-opt seccomp=seccomp-perf.json -v /dev/shm/multicol:/u02  -v $CWD/../:/artifacts -e PGPASSWORD=vectordb -e PGUSERNAME=vectordb -e PGDATABASE=vectordb -v $CWD:/vectordb vbase_artifacts &
sleep 20
str=$"\n"
sstr=$(echo -e $str)
echo $sstr
