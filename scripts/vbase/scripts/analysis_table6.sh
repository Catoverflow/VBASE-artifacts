#!/bin/bash

echo "------------VBase Result--------------"
echo ""
echo "*Query 1, Selectivity=0.03"
python3 /artifacts/scripts/result_analysis/recall.py --path-gt /artifacts/scripts/postgres/query_run/table6/groundtruth/query_selectivity_0.03_gt.out --path-query /artifacts/scripts/vbase/query_run/table6/result/query_selectivity_0.03_vbase.out
python3 /artifacts/scripts/result_analysis/latency.py --path-result /artifacts/scripts/vbase/query_run/table6/result/query_selectivity_0.03_vbase.out 
echo ""
echo "*Query 2, Selectivity=0.3"
python3 /artifacts/scripts/result_analysis/recall.py --path-gt /artifacts/scripts/postgres/query_run/table6/groundtruth/query_selectivity_0.3_gt.out --path-query /artifacts/scripts/vbase/query_run/table6/result/query_selectivity_0.3_vbase.out
python3 /artifacts/scripts/result_analysis/latency.py --path-result /artifacts/scripts/vbase/query_run/table6/result/query_selectivity_0.3_vbase.out 
echo ""
echo "*Query 3, Selectivity=0.9"
python3 /artifacts/scripts/result_analysis/recall.py --path-gt /artifacts/scripts/postgres/query_run/table6/groundtruth/query_selectivity_0.9_gt.out --path-query /artifacts/scripts/vbase/query_run/table6/result/query_selectivity_0.9_vbase.out
python3 /artifacts/scripts/result_analysis/latency.py --path-result /artifacts/scripts/vbase/query_run/table6/result/query_selectivity_0.9_vbase.out 
