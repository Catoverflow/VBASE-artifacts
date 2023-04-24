#!/bin/bash
rm /artifacts/scripts/postgres/query_run/table6/result/query_selectivity_0.3_gt.out
echo "Start to run postgresql query with selectivity=0.3 in Table-6 of paper"
psql -U vectordb -f /artifacts/scripts/postgres/query_run/table6/sql/query_selectivity_0.3_gt.sql > /artifacts/scripts/postgres/query_run/table6/result/query_selectivity_0.3_gt.out

