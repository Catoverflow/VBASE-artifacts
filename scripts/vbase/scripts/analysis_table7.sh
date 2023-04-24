#!/bin/bash

echo "------------VBase Result--------------"
echo ""
python3 /artifacts/scripts/result_analysis/recall.py --path-gt /artifacts/scripts/postgres/query_run/table5/groundtruth/query_7_gt.out --path-query /artifacts/scripts/vbase/query_run/table5/result/query_7_vbase.out
python3 /artifacts/scripts/result_analysis/latency.py --path-result /artifacts/scripts/vbase/query_run/table5/result/query_7_vbase.out 
