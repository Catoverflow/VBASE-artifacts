#!/bin/bash
echo "Table-6 Query Running. It will take about 2 hours and 10 minutes."
echo "Run Queries in Table-6 by PASE"
docker exec --privileged --user=root vbase_artifacts bash -c "/artifacts/scripts/pase/scripts/run_table6.sh"

echo "Run Queries in Table-6 by VBase"
docker exec --privileged --user=root vbase_artifacts bash -c "/artifacts/scripts/vbase/scripts/run_table6.sh"


echo "Save and Analaysis Results..."
echo "Table-6"
echo "--------------------------------------------------"
docker exec --privileged --user=root vbase_artifacts bash -c "/artifacts/scripts/pase/scripts/analysis_table6.sh"
docker exec --privileged --user=root vbase_artifacts bash -c "/artifacts/scripts/vbase/scripts/analysis_table6.sh"
echo "--------------------------------------------------"
