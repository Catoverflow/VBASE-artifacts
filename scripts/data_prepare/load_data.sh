#!/bin/bash

docker exec --privileged --user=root vbase_artifacts bash -c "/artifacts/scripts/vbase/scripts/load_data.sh"
docker exec --privileged --user=root vbase_artifacts bash -c "/artifacts/scripts/pase/scripts/load_data.sh"
docker exec --privileged --user=root vbase_artifacts bash -c "/artifacts/scripts/postgres/scripts/load_data.sh"
docker exec --privileged --user=root vectordb_cyq bash -c "/artifacts/scripts/multi_column/load_data.sh"
