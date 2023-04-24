#!/bin/bash

echo "------------PASE Result--------------"
echo ""
echo "*K'=100"
python3 /artifacts/scripts/result_analysis/recall.py --path-gt /artifacts/scripts/postgres/query_run/table5/groundtruth/query_7_gt.out --path-query /artifacts/scripts/pase/query_run/table7/result/query_range_r_k_100_pase.out
python3 /artifacts/scripts/result_analysis/latency.py --path-result /artifacts/scripts/pase/query_run/table7/result/query_range_r_k_100_pase.out
echo ""
echo "*K'=1000"
python3 /artifacts/scripts/result_analysis/recall.py --path-gt /artifacts/scripts/postgres/query_run/table5/groundtruth/query_7_gt.out --path-query /artifacts/scripts/pase/query_run/table7/result/query_range_r_k_1000_pase.out
python3 /artifacts/scripts/result_analysis/latency.py --path-result /artifacts/scripts/pase/query_run/table7/result/query_range_r_k_1000_pase.out
echo ""
echo "*K'=10000"
python3 /artifacts/scripts/result_analysis/recall.py --path-gt /artifacts/scripts/postgres/query_run/table5/groundtruth/query_7_gt.out --path-query /artifacts/scripts/pase/query_run/table7/result/query_range_r_k_10000_pase.out
python3 /artifacts/scripts/result_analysis/latency.py --path-result /artifacts/scripts/pase/query_run/table7/result/query_range_r_k_10000_pase.out
