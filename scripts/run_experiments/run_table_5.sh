#!/bin/bash
DIRPATH=$(dirname "$0")
PATH_VBench="${DIRPATH}/../../VBench"
echo "Table-5 Query Running. It will take about 3 hours and 30 minutes."

echo "Run Queries in Table-5 by PostgreSQL"
#echo "(the expected time is 1 hour and 20 minutes)"
#docker exec --privileged --user=root vbase_artifacts bash -c "/artifacts/scripts/postgres/scripts/run.sh"
docker exec --privileged --user=root vbase_artifacts bash -c "/artifacts/scripts/postgres/scripts/run_sample.sh"

echo "Run Queries in Table-5 by PASE"
docker exec --privileged --user=root vbase_artifacts bash -c "/artifacts/scripts/pase/scripts/run_table5.sh"

echo "Run Queries in Table-5 by Milvus"
bash ${PATH_VBench}/clearresult.sh
bash ${PATH_VBench}/artifact_milvus.sh

echo "Run Queries in Table-5 by Elasticsearch"
bash ${PATH_VBench}/artifact_es.sh

echo "Run Queries in Table-5 by VBase"
docker exec --privileged --user=root vbase_artifacts bash -c "/artifacts/scripts/vbase/scripts/run_table5.sh"

echo "Save and Analaysis Results..."
echo "Table-5"
echo "--------------------------------------------------"
docker exec --privileged --user=root vbase_artifacts bash -c "/artifacts/scripts/postgres/scripts/analysis_table5.sh"
docker exec --privileged --user=root vbase_artifacts bash -c "/artifacts/scripts/postgres/scripts/analysis_table5_sample.sh"
docker exec --privileged --user=root vbase_artifacts bash -c "/artifacts/scripts/pase/scripts/analysis_table5.sh"
bash ${PATH_VBench}/eval/milvus.sh
bash ${PATH_VBench}/eval/elasticsearch.sh
docker exec --privileged --user=root vbase_artifacts bash -c "/artifacts/scripts/vbase/scripts/analysis_table5.sh"
echo "--------------------------------------------------"
