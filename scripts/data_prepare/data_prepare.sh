#!/bin/bash

docker exec --privileged --user=root vbase_artifacts bash -c "/artifacts/scripts/data_prepare/cook_data.sh"
docker exec --privileged --user=root vbase_artifacts bash -c "/artifacts/scripts/vbase/scripts/query_generate.sh"
docker exec --privileged --user=root vbase_artifacts bash -c "/artifacts/scripts/pase/scripts/query_generate.sh"
docker exec --privileged --user=root vbase_artifacts bash -c "/artifacts/scripts/postgres/scripts/query_generate.sh"
docker exec --privileged --user=root vbase_artifacts bash -c "python3 /artifacts/vectordb/queries/gen_query.py"
