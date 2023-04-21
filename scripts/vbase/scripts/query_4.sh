#!/bin/bash
rm /artifacts/scripts/vbase/query_run/table5/result/query_4_vbase.out >/dev/null 2>&1
#echo "Start to run VBase query 4 in Table-5 of paper" 
psql -U vectordb -f /artifacts/scripts/vbase/query_run/table5/sql/query_4_vbase.sql > /artifacts/scripts/vbase/query_run/table5/result/query_4_vbase.out

