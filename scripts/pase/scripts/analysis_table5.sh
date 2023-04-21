#!/bin/bash

echo "------------PASE Result--------------"
echo ""
echo "*Query 1"
python3 /artifacts/scripts/result_analysis/recall.py --path-gt /artifacts/scripts/postgres/query_run/table5/groundtruth/query_1_gt.out --path-query /artifacts/scripts/pase/query_run/table5/result/query_1_pase.out
python3 /artifacts/scripts/result_analysis/latency.py --path-result /artifacts/scripts/pase/query_run/table5/result/query_1_pase.out 
echo ""
echo "*Query 2"
python3 /artifacts/scripts/result_analysis/recall.py --path-gt /artifacts/scripts/postgres/query_run/table5/groundtruth/query_2_gt.out --path-query /artifacts/scripts/pase/query_run/table5/result/query_2_pase.out
python3 /artifacts/scripts/result_analysis/latency.py --path-result /artifacts/scripts/pase/query_run/table5/result/query_2_pase.out 
echo ""
echo "*Query 3"
python3 /artifacts/scripts/result_analysis/recall.py --path-gt /artifacts/scripts/postgres/query_run/table5/groundtruth/query_3_gt.out --path-query /artifacts/scripts/pase/query_run/table5/result/query_3_pase.out
python3 /artifacts/scripts/result_analysis/latency.py --path-result /artifacts/scripts/pase/query_run/table5/result/query_3_pase.out 
