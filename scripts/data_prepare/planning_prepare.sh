#!/usr/bin/bash
RECIPE1M_TSV=$(pwd)/data_source.tsv
if ! test -f $RECIPE1M_TSV; then
    echo "$RECIPE1M_TSV missing, aborted."
    exit -1
fi
mkdir -p ../planning/tmp
if ! test -f ../planning/tmp/datasource_1col.tsv; then
    echo "Extracting column 2 from ${RECIPE1M_TSV}..."
    cut -f 2 $RECIPE1M_TSV > ../planning/tmp/datasource_1col.tsv
fi
# in paper we use this sample rate for demonstration,
# and 330922 = `select count * from Recipe`
SAMPLE_FACTOR=1000
echo "Sampling 1/$SAMPLE_FACTOR of the data..."
shuf -n $((330922 / $SAMPLE_FACTOR)) ../planning/tmp/datasource_1col.tsv > ../planning/tmp/datasource_1col_sample.tsv
docker cp ./planning_prepare.sql vbase_planning_esti:/tmp/
docker cp ./planning_prepare.sql vbase_planning_exec:/tmp/
docker exec vbase_planning_esti bash -c "PGPASSWORD=vectordb && psql -U vectordb -f /tmp/planning_prepare.sql"
docker exec vbase_planning_exec bash -c "PGPASSWORD=vectordb && psql -U vectordb -f /tmp/planning_prepare.sql"
