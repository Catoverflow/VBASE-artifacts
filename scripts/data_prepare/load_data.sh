#!/bin/bash
DIRPATH=$(dirname "$0")
docker exec --privileged --user=root vbase_artifacts bash -c "/artifacts/scripts/vbase/scripts/load_data.sh"
docker exec --privileged --user=root vbase_artifacts bash -c "/artifacts/scripts/pase/scripts/load_data.sh"
docker exec --privileged --user=root vbase_artifacts bash -c "/artifacts/scripts/postgres/scripts/load_data.sh"
docker exec --privileged --user=root vectordb_cyq bash -c "/artifacts/scripts/multi_column/load_data.sh"
(cd $(dirname "$0") && ./planning_prepare.sh)
(cd $DIRPATH/../../VBench && bash prepare.sh)
