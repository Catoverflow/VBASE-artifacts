#!/bin/bash
rm /artifact/scripts/postgres/query_run/table6/result/query_selectivity_0.03_gt.out
echo "Start to run postgresql query with selectivity=0.03 in Table-6 of paper"
psql -U vectordb -f /artifacts/scripts/postgres/query_run/table6/sql/query_selectivity_0.03_gt.sql > /artifacts/scripts/postgres/query_run/table6/result/query_selectivity_0.03_gt.out

