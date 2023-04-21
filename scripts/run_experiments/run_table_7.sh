#!/bin/bash
echo "Table-7 Query Running. It will take about 1 hour and 40 minutes."
echo "Run Queries in Table-7 by PASE"
#echo "(the expected time is 1 hour and 20 minutes)"
docker exec --privileged --user=root vbase_artifacts bash -c "/artifacts/scripts/pase/scripts/run_table7.sh"


echo "Save and Analaysis Results..."
echo "Table-7"
echo "--------------------------------------------------"
docker exec --privileged --user=root vbase_artifacts bash -c "/artifacts/scripts/pase/scripts/analysis_table7.sh"
docker exec --privileged --user=root vbase_artifacts bash -c "/artifacts/scripts/vbase/scripts/analysis_table7.sh"
echo "--------------------------------------------------"
