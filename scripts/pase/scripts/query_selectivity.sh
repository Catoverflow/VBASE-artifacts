#!/bin/bash
cp /tmp/vectordb/eval_src/pase_hnswindex_ef_100.cpp /tmp/vectordb/src/pase_hnswindex.cpp && cd /tmp/vectordb/build && make -j40  >/dev/null 2>&1 && make install >/dev/null 2>&1
rm /artifacts/scripts/pase/query_run/table6/result/query_selectivity_0.03_k_100_pase.out >/dev/null 2>&1
#echo "Start to run PASE query with selectivity=0.03 and K = 100 in Table-6 of paper"
psql -U vectordb -f /artifacts/scripts/pase/query_run/table6/sql/query_selectivity_0.03_k_100_pase.sql > /artifacts/scripts/pase/query_run/table6/result/query_selectivity_0.03_k_100_pase.out

rm /artifacts/scripts/pase/query_run/table6/result/query_selectivity_0.3_k_100_pase.out >/dev/null 2>&1
#echo "Start to run PASE query with selectivity=0.3 and K = 100 in Table-6 of paper"
psql -U vectordb -f /artifacts/scripts/pase/query_run/table6/sql/query_selectivity_0.3_k_100_pase.sql > /artifacts/scripts/pase/query_run/table6/result/query_selectivity_0.3_k_100_pase.out

rm /artifacts/scripts/pase/query_run/table6/result/query_selectivity_0.9_k_100_pase.out >/dev/null 2>&1
#echo "Start to run PASE query with selectivity=0.9 and K = 100 in Table-6 of paper"
psql -U vectordb -f /artifacts/scripts/pase/query_run/table6/sql/query_selectivity_0.9_k_100_pase.sql > /artifacts/scripts/pase/query_run/table6/result/query_selectivity_0.9_k_100_pase.out

cp /tmp/vectordb/eval_src/pase_hnswindex_ef_1000.cpp /tmp/vectordb/src/pase_hnswindex.cpp && cd /tmp/vectordb/build && make -j40  >/dev/null 2>&1 && make install >/dev/null 2>&1
rm /artifacts/scripts/pase/query_run/table6/result/query_selectivity_0.03_k_1000_pase.out >/dev/null 2>&1
#echo "Start to run PASE query with selectivity=0.03 and K = 1000 in Table-6 of paper"
psql -U vectordb -f /artifacts/scripts/pase/query_run/table6/sql/query_selectivity_0.03_k_1000_pase.sql > /artifacts/scripts/pase/query_run/table6/result/query_selectivity_0.03_k_1000_pase.out

rm /artifacts/scripts/pase/query_run/table6/result/query_selectivity_0.3_k_1000_pase.out >/dev/null 2>&1
#echo "Start to run PASE query with selectivity=0.3 and K = 1000 in Table-6 of paper"
psql -U vectordb -f /artifacts/scripts/pase/query_run/table6/sql/query_selectivity_0.3_k_1000_pase.sql > /artifacts/scripts/pase/query_run/table6/result/query_selectivity_0.3_k_1000_pase.out

rm /artifacts/scripts/pase/query_run/table6/result/query_selectivity_0.9_k_1000_pase.out >/dev/null 2>&1
#echo "Start to run PASE query with selectivity=0.9 and K = 1000 in Table-6 of paper"
psql -U vectordb -f /artifacts/scripts/pase/query_run/table6/sql/query_selectivity_0.9_k_1000_pase.sql > /artifacts/scripts/pase/query_run/table6/result/query_selectivity_0.9_k_1000_pase.out

cp /tmp/vectordb/eval_src/pase_hnswindex_ef_10000.cpp /tmp/vectordb/src/pase_hnswindex.cpp && cd /tmp/vectordb/build && make -j40  >/dev/null 2>&1 && make install >/dev/null 2>&1
rm /artifacts/scripts/pase/query_run/table6/result/query_selectivity_0.03_k_10000_pase.out >/dev/null 2>&1
#echo "Start to run PASE query with selectivity=0.03 and K = 10000 in Table-6 of paper"
psql -U vectordb -f /artifacts/scripts/pase/query_run/table6/sql/query_selectivity_0.03_k_10000_pase.sql > /artifacts/scripts/pase/query_run/table6/result/query_selectivity_0.03_k_10000_pase.out

rm /artifacts/scripts/pase/query_run/table6/result/query_selectivity_0.3_k_10000_pase.out >/dev/null 2>&1
#echo "Start to run PASE query with selectivity=0.3 and K = 10000 in Table-6 of paper"
psql -U vectordb -f /artifacts/scripts/pase/query_run/table6/sql/query_selectivity_0.3_k_10000_pase.sql > /artifacts/scripts/pase/query_run/table6/result/query_selectivity_0.3_k_10000_pase.out

rm /artifacts/scripts/pase/query_run/table6/result/query_selectivity_0.9_k_10000_pase.out >/dev/null 2>&1
#echo "Start to run PASE query with selectivity=0.9 and K = 10000 in Table-6 of paper"
psql -U vectordb -f /artifacts/scripts/pase/query_run/table6/sql/query_selectivity_0.9_k_10000_pase.sql > /artifacts/scripts/pase/query_run/table6/result/query_selectivity_0.9_k_10000_pase.out

