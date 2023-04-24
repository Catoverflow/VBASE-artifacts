#!/bin/bash
rm /artifacts/scripts/postgres/query_run/table5_sample/result/query_3_gt.out >/dev/null 2>&1
#echo "Start to run PostgreSQL query 3 in Table-5 of paper"
psql -U vectordb -f /artifacts/scripts/postgres/query_run/table5_sample/sql/query_3_gt.sql > /artifacts/scripts/postgres/query_run/table5_sample/result/query_3_gt.out

