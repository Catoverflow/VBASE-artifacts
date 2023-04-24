#!/bin/bash
rm /artifacts/scripts/postgres/query_run/table5_sample/result/query_1_gt.out >/dev/null 2>&1
#echo "Start to run PostgreSQL query 1 in Table-5 of paper"
psql -U vectordb -f /artifacts/scripts/postgres/query_run/table5_sample/sql/query_1_gt.sql > /artifacts/scripts/postgres/query_run/table5_sample/result/query_1_gt.out

