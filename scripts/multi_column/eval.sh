#!/bin/bash
echo "1:1"
docker exec -it vectordb_cyq bash -c "python3 /vectordb/eval.py --gt /vectordb/groundtruth/gt.txt --round-robin /vectordb/before.txt --vbase /vectordb/after.txt --greedy /vectordb/greedy.txt"
echo " "
echo "1:2"
docker exec -it vectordb_cyq bash -c "python3 /vectordb/eval.py --gt /vectordb/groundtruth/gt_1_2.txt --round-robin /vectordb/before_1_2.txt --vbase /vectordb/after_1_2.txt --greedy /vectordb/greedy_1_2.txt"
echo " "
echo "1:5"
docker exec -it vectordb_cyq bash -c "python3 /vectordb/eval.py --gt /vectordb/groundtruth/gt_1_5.txt --round-robin /vectordb/before_1_5.txt --vbase /vectordb/after_1_5.txt --greedy /vectordb/greedy_1_5.txt"
echo " "
echo "1:10"
docker exec -it vectordb_cyq bash -c "python3 /vectordb/eval.py --gt /vectordb/groundtruth/gt_1_10.txt --round-robin /vectordb/before_1_10.txt --vbase /vectordb/after_1_10.txt --greedy /vectordb/greedy_1_10.txt"

