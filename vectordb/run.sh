#!/bin/bash

# round-robin
cp ./topk_src/topk_round_robin.cpp ./src/topk.cpp
docker exec -it -u 0 vectordb_cyq bash -c "cd /vectordb/build && cmake .. > build.log 2>&1 && make -j 8 > build.log 2>&1 && make install > build.log 2>&1"

echo "running round-robin 1:1 ..."
docker exec -it vectordb_cyq bash -c "cd vectordb && psql -U vectordb -f ./queries/query.sql > before.txt 2>&1"
echo "running round-robin 1:2 ..."
docker exec -it vectordb_cyq bash -c "cd vectordb && psql -U vectordb -f ./queries/query_1_2.sql > before_1_2.txt 2>&1"
echo "running round-robin 1:5 ..."
docker exec -it vectordb_cyq bash -c "cd vectordb && psql -U vectordb -f ./queries/query_1_5.sql > before_1_5.txt 2>&1"
echo "running round-robin 1:10 ..."
docker exec -it vectordb_cyq bash -c "cd vectordb && psql -U vectordb -f ./queries/query_1_10.sql > before_1_10.txt 2>&1"

rm /dev/shm/pg/pgdata/13/pg_log/*

# vbase
cp ./topk_src/topk_opt.cpp ./src/topk.cpp
docker exec -it -u 0 vectordb_cyq bash -c "cd /vectordb/build && cmake .. > build.log 2>&1 && make -j 8 > build.log 2>&1 && make install > build.log 2>&1"

echo "running vbase 1:1 ..."
docker exec -it vectordb_cyq bash -c "cd vectordb && psql -U vectordb -f ./queries/query.sql > after.txt 2>&1"
echo "running vbase 1:2 ..."
docker exec -it vectordb_cyq bash -c "cd vectordb && psql -U vectordb -f ./queries/query_1_2.sql > after_1_2.txt 2>&1"
echo "running vbase 1:5 ..."
docker exec -it vectordb_cyq bash -c "cd vectordb && psql -U vectordb -f ./queries/query_1_5.sql > after_1_5.txt 2>&1"
echo "running vbase 1:10 ..."
docker exec -it vectordb_cyq bash -c "cd vectordb && psql -U vectordb -f ./queries/query_1_10.sql > after_1_10.txt 2>&1"

rm /dev/shm/pg/pgdata/13/pg_log/*

# greedy
cp ./topk_src/topk_greedy.cpp ./src/topk.cpp
docker exec -it -u 0 vectordb_cyq bash -c "cd /vectordb/build && cmake .. > build.log 2>&1 && make -j 8 > build.log 2>&1 && make install > build.log 2>&1"

echo "running greedy 1:1 ..."
docker exec -it vectordb_cyq bash -c "cd vectordb && psql -U vectordb -f ./queries/query.sql > greedy.txt 2>&1"
echo "running greedy 1:2 ..."
docker exec -it vectordb_cyq bash -c "cd vectordb && psql -U vectordb -f ./queries/query_1_2.sql > greedy_1_2.txt 2>&1"
echo "running greedy 1:5 ..."
docker exec -it vectordb_cyq bash -c "cd vectordb && psql -U vectordb -f ./queries/query_1_5.sql > greedy_1_5.txt 2>&1"
echo "running greedy 1:10 ..."
docker exec -it vectordb_cyq bash -c "cd vectordb && psql -U vectordb -f ./queries/query_1_10.sql > greedy_1_10.txt 2>&1"

rm /dev/shm/pg/pgdata/13/pg_log/*

# eval
echo "1:1"
python3 ./eval.py --gt "./groundtruth/gt.txt" --round-robin "./before.txt" --vbase "./after.txt" --greedy "./greedy.txt"
echo " "
echo "1:2"
python3 ./eval.py --gt "./groundtruth/gt_1_2.txt" --round-robin "./before_1_2.txt" --vbase "./after_1_2.txt" --greedy "./greedy_1_2.txt"
echo " "
echo "1:5"
python3 ./eval.py --gt "./groundtruth/gt_1_5.txt" --round-robin "./before_1_5.txt" --vbase "./after_1_5.txt" --greedy "./greedy_1_5.txt"
echo " "
echo "1:10"
python3 ./eval.py --gt "./groundtruth/gt_1_10.txt" --round-robin "./before_1_10.txt" --vbase "./after_1_10.txt" --greedy "./greedy_1_10.txt"

cp ./topk_src/topk_ori.cpp ./src/topk.cpp