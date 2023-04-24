#!/bin/bash

echo "------------PostgreSQL Sample Result--------------"
echo ""
echo "*Query 1"
python3 /artifacts/scripts/result_analysis/latency.py --path-result /artifacts/scripts/postgres/query_run/table5_sample/result/query_1_gt.out 
echo ""
echo "*Query 2"
python3 /artifacts/scripts/result_analysis/latency.py --path-result /artifacts/scripts/postgres/query_run/table5_sample/result/query_2_gt.out 
echo ""
echo "*Query 3"
python3 /artifacts/scripts/result_analysis/latency.py --path-result /artifacts/scripts/postgres/query_run/table5_sample/result/query_3_gt.out 
echo ""
echo "*Query 4"
python3 /artifacts/scripts/result_analysis/latency.py --path-result /artifacts/scripts/postgres/query_run/table5_sample/result/query_4_gt.out 
echo ""
echo "*Query 5"
python3 /artifacts/scripts/result_analysis/latency.py --path-result /artifacts/scripts/postgres/query_run/table5_sample/result/query_5_gt.out 
echo ""
echo "*Query 6"
python3 /artifacts/scripts/result_analysis/latency.py --path-result /artifacts/scripts/postgres/query_run/table5_sample/result/query_6_gt.out 
echo ""
echo "*Query 7"
python3 /artifacts/scripts/result_analysis/latency.py --path-result /artifacts/scripts/postgres/query_run/table5_sample/result/query_7_gt.out 
echo ""
