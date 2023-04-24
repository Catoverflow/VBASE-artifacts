#/bin/bash
echo "------------PASE Result--------------"
echo ""
echo "*K'=100, Selectivity=0.03"
python3 /artifacts/scripts/result_analysis/recall.py --path-gt /artifacts/scripts/postgres/query_run/table6/groundtruth/query_selectivity_0.03_gt.out --path-query /artifacts/scripts/pase/query_run/table6/result/query_selectivity_0.03_k_100_pase.out
python3 /artifacts/scripts/result_analysis/latency.py --path-result /artifacts/scripts/pase/query_run/table6/result/query_selectivity_0.03_k_100_pase.out
echo ""
echo "*K'=100, Selectivity=0.3"
python3 /artifacts/scripts/result_analysis/recall.py --path-gt /artifacts/scripts/postgres/query_run/table6/groundtruth/query_selectivity_0.3_gt.out --path-query /artifacts/scripts/pase/query_run/table6/result/query_selectivity_0.3_k_100_pase.out
python3 /artifacts/scripts/result_analysis/latency.py --path-result /artifacts/scripts/pase/query_run/table6/result/query_selectivity_0.3_k_100_pase.out
echo ""
echo "*K'=100, Selectivity=0.9"
python3 /artifacts/scripts/result_analysis/recall.py --path-gt /artifacts/scripts/postgres/query_run/table6/groundtruth/query_selectivity_0.9_gt.out --path-query /artifacts/scripts/pase/query_run/table6/result/query_selectivity_0.9_k_100_pase.out
python3 /artifacts/scripts/result_analysis/latency.py --path-result /artifacts/scripts/pase/query_run/table6/result/query_selectivity_0.9_k_100_pase.out
echo ""
echo "*K'=1000, Selectivity=0.03"
python3 /artifacts/scripts/result_analysis/recall.py --path-gt /artifacts/scripts/postgres/query_run/table6/groundtruth/query_selectivity_0.03_gt.out --path-query /artifacts/scripts/pase/query_run/table6/result/query_selectivity_0.03_k_1000_pase.out
python3 /artifacts/scripts/result_analysis/latency.py --path-result /artifacts/scripts/pase/query_run/table6/result/query_selectivity_0.03_k_1000_pase.out
echo ""
echo "*K'=1000, Selectivity=0.3"
python3 /artifacts/scripts/result_analysis/recall.py --path-gt /artifacts/scripts/postgres/query_run/table6/groundtruth/query_selectivity_0.3_gt.out --path-query /artifacts/scripts/pase/query_run/table6/result/query_selectivity_0.3_k_1000_pase.out
python3 /artifacts/scripts/result_analysis/latency.py --path-result /artifacts/scripts/pase/query_run/table6/result/query_selectivity_0.3_k_1000_pase.out
echo ""
echo "*K'=1000, Selectivity=0.9"
python3 /artifacts/scripts/result_analysis/recall.py --path-gt /artifacts/scripts/postgres/query_run/table6/groundtruth/query_selectivity_0.9_gt.out --path-query /artifacts/scripts/pase/query_run/table6/result/query_selectivity_0.9_k_1000_pase.out
python3 /artifacts/scripts/result_analysis/latency.py --path-result /artifacts/scripts/pase/query_run/table6/result/query_selectivity_0.9_k_1000_pase.out
echo ""
echo "*K'=10000, Selectivity=0.03"
python3 /artifacts/scripts/result_analysis/recall.py --path-gt /artifacts/scripts/postgres/query_run/table6/groundtruth/query_selectivity_0.03_gt.out --path-query /artifacts/scripts/pase/query_run/table6/result/query_selectivity_0.03_k_10000_pase.out
python3 /artifacts/scripts/result_analysis/latency.py --path-result /artifacts/scripts/pase/query_run/table6/result/query_selectivity_0.03_k_10000_pase.out
echo ""
echo "*K'=10000, Selectivity=0.3"
python3 /artifacts/scripts/result_analysis/recall.py --path-gt /artifacts/scripts/postgres/query_run/table6/groundtruth/query_selectivity_0.3_gt.out --path-query /artifacts/scripts/pase/query_run/table6/result/query_selectivity_0.3_k_10000_pase.out
python3 /artifacts/scripts/result_analysis/latency.py --path-result /artifacts/scripts/pase/query_run/table6/result/query_selectivity_0.3_k_10000_pase.out
echo ""
echo "*K'=10000, Selectivity=0.9"
python3 /artifacts/scripts/result_analysis/recall.py --path-gt /artifacts/scripts/postgres/query_run/table6/groundtruth/query_selectivity_0.9_gt.out --path-query /artifacts/scripts/pase/query_run/table6/result/query_selectivity_0.9_k_10000_pase.out
python3 /artifacts/scripts/result_analysis/latency.py --path-result /artifacts/scripts/pase/query_run/table6/result/query_selectivity_0.9_k_10000_pase.out
