#!/bin/bash
rm /artifacts/scripts/vbase/query_run/table5/result/query_8_vbase.out >/dev/null 2>&1
#echo "Start to run vbase query 8 in Table-5 of paper"
psql -U vectordb -f /artifacts/scripts/vbase/query_run/table5/sql/query_8_vbase.sql > /artifacts/scripts/vbase/query_run/table5/result/query_8_vbase.out

