#!/bin/bash

echo "------------VBase Result--------------"
echo ""
echo "*Query 1"
python3 /artifacts/scripts/result_analysis/recall.py --path-gt /artifacts/scripts/postgres/query_run/table5/groundtruth/query_1_gt.out --path-query /artifacts/scripts/vbase/query_run/table5/result/query_1_vbase.out
python3 /artifacts/scripts/result_analysis/latency.py --path-result /artifacts/scripts/vbase/query_run/table5/result/query_1_vbase.out 
echo ""
echo "*Query 2"
python3 /artifacts/scripts/result_analysis/recall.py --path-gt /artifacts/scripts/postgres/query_run/table5/groundtruth/query_2_gt.out --path-query /artifacts/scripts/vbase/query_run/table5/result/query_2_vbase.out
python3 /artifacts/scripts/result_analysis/latency.py --path-result /artifacts/scripts/vbase/query_run/table5/result/query_2_vbase.out 
echo ""
echo "*Query 3"
python3 /artifacts/scripts/result_analysis/recall.py --path-gt /artifacts/scripts/postgres/query_run/table5/groundtruth/query_3_gt.out --path-query /artifacts/scripts/vbase/query_run/table5/result/query_3_vbase.out
python3 /artifacts/scripts/result_analysis/latency.py --path-result /artifacts/scripts/vbase/query_run/table5/result/query_3_vbase.out 
echo ""
echo "*Query 4"
python3 /artifacts/scripts/result_analysis/recall.py --path-gt /artifacts/scripts/postgres/query_run/table5/groundtruth/query_4_gt.out --path-query /artifacts/scripts/vbase/query_run/table5/result/query_4_vbase.out
python3 /artifacts/scripts/result_analysis/latency.py --path-result /artifacts/scripts/vbase/query_run/table5/result/query_4_vbase.out 
echo ""
echo "*Query 5"
python3 /artifacts/scripts/result_analysis/recall.py --path-gt /artifacts/scripts/postgres/query_run/table5/groundtruth/query_5_gt.out --path-query /artifacts/scripts/vbase/query_run/table5/result/query_5_vbase.out
python3 /artifacts/scripts/result_analysis/latency.py --path-result /artifacts/scripts/vbase/query_run/table5/result/query_5_vbase.out 
echo ""
echo "*Query 6"
python3 /artifacts/scripts/result_analysis/recall.py --path-gt /artifacts/scripts/postgres/query_run/table5/groundtruth/query_6_gt.out --path-query /artifacts/scripts/vbase/query_run/table5/result/query_6_vbase.out
python3 /artifacts/scripts/result_analysis/latency.py --path-result /artifacts/scripts/vbase/query_run/table5/result/query_6_vbase.out 
echo ""
echo "*Query 7"
python3 /artifacts/scripts/result_analysis/recall.py --path-gt /artifacts/scripts/postgres/query_run/table5/groundtruth/query_7_gt.out --path-query /artifacts/scripts/vbase/query_run/table5/result/query_7_vbase.out
python3 /artifacts/scripts/result_analysis/latency.py --path-result /artifacts/scripts/vbase/query_run/table5/result/query_7_vbase.out 
echo ""
echo "*Query 8"
python3 /artifacts/scripts/result_analysis/recall_q8.py  --path-query /artifacts/scripts/vbase/query_run/table5/result/query_8_vbase.out
python3 /artifacts/scripts/result_analysis/latency.py --path-result /artifacts/scripts/vbase/query_run/table5/result/query_8_vbase.out 
