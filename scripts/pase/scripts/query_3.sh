#!/bin/bash
rm /artifacts/scripts/pase/query_run/table5/result/query_3_pase.out >/dev/null 2>&1
cp /tmp/vectordb/eval_src/pase_hnswindex_ef_600.cpp /tmp/vectordb/src/pase_hnswindex.cpp && cd /tmp/vectordb/build && make -j40  >/dev/null 2>&1 && make install >/dev/null 2>&1
#echo "Start to run PASE query 3 in Table-5 of paper"
psql -U vectordb -f /artifacts/scripts/pase/query_run/table5/sql/query_3_pase.sql > /artifacts/scripts/pase/query_run/table5/result/query_3_pase.out

