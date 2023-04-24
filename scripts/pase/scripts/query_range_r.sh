#!/bin/bash
rm /artifacts/scripts/pase/query_run/table7/result/query_range_r_k_100_pase.out >/dev/null 2>&1
rm /artifacts/scripts/pase/query_run/table7/result/query_range_r_k_1000_pase.out >/dev/null 2>&1
rm /artifacts/scripts/pase/query_run/table7/result/query_range_r_k_10000_pase.out >/dev/null 2>&1
#echo "Start to run PASE query in Table-7 of paper"

cp /tmp/vectordb/eval_src/pase_hnswindex_ef_100.cpp /tmp/vectordb/src/pase_hnswindex.cpp && cd /tmp/vectordb/build && make -j40  >/dev/null 2>&1 && make install >/dev/null 2>&1
psql -U vectordb -f /artifacts/scripts/pase/query_run/table7/sql/query_range_r_pase.sql > /artifacts/scripts/pase/query_run/table7/result/query_range_r_k_100_pase.out

cp /tmp/vectordb/eval_src/pase_hnswindex_ef_1000.cpp /tmp/vectordb/src/pase_hnswindex.cpp && cd /tmp/vectordb/build && make -j40  >/dev/null 2>&1 && make install >/dev/null 2>&1
psql -U vectordb -f /artifacts/scripts/pase/query_run/table7/sql/query_range_r_pase.sql > /artifacts/scripts/pase/query_run/table7/result/query_range_r_k_1000_pase.out

cp /tmp/vectordb/eval_src/pase_hnswindex_ef_10000.cpp /tmp/vectordb/src/pase_hnswindex.cpp && cd /tmp/vectordb/build && make -j40  >/dev/null 2>&1 && make install >/dev/null 2>&1
psql -U vectordb -f /artifacts/scripts/pase/query_run/table7/sql/query_range_r_pase.sql > /artifacts/scripts/pase/query_run/table7/result/query_range_r_k_10000_pase.out
