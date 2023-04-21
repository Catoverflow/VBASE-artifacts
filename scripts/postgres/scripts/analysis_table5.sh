#!/bin/bash

echo "------------PostgreSQL Result--------------"
echo ""
echo "*Query 1"
python3 /artifacts/scripts/result_analysis/latency.py --path-result /artifacts/scripts/postgres/query_run/table5/result/query_1_gt.out 
echo ""
echo "*Query 2"
python3 /artifacts/scripts/result_analysis/latency.py --path-result /artifacts/scripts/postgres/query_run/table5/result/query_2_gt.out 
echo ""
echo "*Query 3"
python3 /artifacts/scripts/result_analysis/latency.py --path-result /artifacts/scripts/postgres/query_run/table5/result/query_3_gt.out 
echo ""
echo "*Query 4"
python3 /artifacts/scripts/result_analysis/latency.py --path-result /artifacts/scripts/postgres/query_run/table5/result/query_4_gt.out 
echo ""
echo "*Query 5"
python3 /artifacts/scripts/result_analysis/latency.py --path-result /artifacts/scripts/postgres/query_run/table5/result/query_5_gt.out 
echo ""
echo "*Query 6"
python3 /artifacts/scripts/result_analysis/latency.py --path-result /artifacts/scripts/postgres/query_run/table5/result/query_6_gt.out 
echo ""
echo "*Query 7"
python3 /artifacts/scripts/result_analysis/latency.py --path-result /artifacts/scripts/postgres/query_run/table5/result/query_7_gt.out 
echo ""
echo "*Query 8"
python3 /artifacts/scripts/result_analysis/latency_q8.py --path-result /artifacts/scripts/postgres/query_run/table5/result/query_8_gt.out
