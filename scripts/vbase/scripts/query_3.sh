#!/bin/bash
rm /artifacts/scripts/vbase/query_run/table5/result/query_3_vbase.out >/dev/null 2>&1
cp /tmp/vectordb/eval_src/hnswindex_ef_200.cpp /tmp/vectordb/src/hnswindex.cpp && cd /tmp/vectordb/build && make -j40  >/dev/null 2>&1 && make install >/dev/null 2>&1
#echo "Start to run VBase query 3 in Table-5 of paper"
psql -U vectordb -f /artifacts/scripts/vbase/query_run/table5/sql/query_3_vbase.sql > /artifacts/scripts/vbase/query_run/table5/result/query_3_vbase.out

