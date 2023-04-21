#!/usr/bin/zsh
RECIPE1M_TSV=$(pwd)/datasource.tsv
DBNAME=planning_test
DBUSERNAME=vectordb
DBPASSWORD=vectordb
ADDR=localhost
PORT=15432
PORT_ESTI=25432
alias PSQL_BASE="PGPASSWORD=$DBPASSWORD psql -U $DBUSERNAME -d $DBNAME -h $ADDR -p $PORT"
alias PSQL_ESTI="PGPASSWORD=$DBPASSWORD psql -U $DBUSERNAME -d $DBNAME -h $ADDR -p $PORT_ESTI"
WORKDIR=$(pwd)
cd ../planning
mkdir -p tmp
if ! test -f "tmp/datasource_1col.tsv"; then
    echo "Extracting column 2 from ${RECIPE1M_TSV}..."
    cut -f 2 $RECIPE1M_TSV > tmp/datasource_1col.tsv
fi
# in paper we use this sample rate for demonstration,
# and 330922 = `select count * from Recipe`
SAMPLE_FACTOR=1000
shuf -n $((330922 / $SAMPLE_FACTOR)) tmp/datasource_1col.tsv > tmp/datasource_1col_sample.tsv
PGPASSWORD=$DBPASSWORD psql -U $DBUSERNAME -h $ADDR -p $PORT -c "drop database if exists $DBNAME;"
PGPASSWORD=$DBPASSWORD psql -U $DBUSERNAME -h $ADDR -p $PORT_ESTI -c "drop database if exists $DBNAME;"
PGPASSWORD=$DBPASSWORD createdb -U $DBUSERNAME -h $ADDR -p $PORT $DBNAME "DB for testing planning of vectordb"
PGPASSWORD=$DBPASSWORD createdb -U $DBUSERNAME -h $ADDR -p $PORT_ESTI $DBNAME "DB for testing planning of vectordb"
PSQL_BASE -c "create extension vectordb;  create table Recipe (image_embedding float8[100]);"
PSQL_ESTI -c "create extension vectordb;  create table Recipe (image_embedding float8[100]);"
PSQL_BASE -c "alter table Recipe alter column image_embedding set storage plain;"
PSQL_ESTI -c "alter table Recipe alter column image_embedding set storage plain;"
PSQL_BASE -c "\copy Recipe from 'tmp/datasource_1col.tsv' delimiter E'\t' csv;"
PSQL_ESTI -c "\copy Recipe from 'tmp/datasource_1col.tsv' delimiter E'\t' csv;"
PSQL_BASE -c "alter table Recipe add column recipe_id BIGSERIAL PRIMARY KEY;"
PSQL_ESTI -c "alter table Recipe add column recipe_id BIGSERIAL PRIMARY KEY;"
PSQL_BASE -c "alter table Recipe add column popularity int; update Recipe set popularity = 330922*random();"
PSQL_ESTI -c "alter table Recipe add column popularity int; update Recipe set popularity = 330922*random();"
# we create two identical tables with different index to collect planning & executing costs,
PSQL_BASE -c "create table Recipe_scalar (image_embedding float8[1024], popularity int);"
PSQL_ESTI -c "create table Recipe_scalar (image_embedding float8[1024], popularity int);"
PSQL_BASE -c "alter table Recipe_scalar alter column image_embedding set storage plain;"
PSQL_ESTI -c "alter table Recipe_scalar alter column image_embedding set storage plain;"
PSQL_BASE -c "insert into Recipe_scalar (image_embedding, popularity) select image_embedding, popularity from Recipe;"
PSQL_ESTI -c "insert into Recipe_scalar (image_embedding, popularity) select image_embedding, popularity from Recipe;"
# make sure recipe_scalar's storage is partitioned on id
# as id is not used in following tests, there's no need to be the same as Recipe
PSQL_BASE -c "alter table Recipe_scalar add column recipe_id BIGSERIAL PRIMARY KEY;"
PSQL_ESTI -c "alter table Recipe_scalar add column recipe_id BIGSERIAL PRIMARY KEY;"
# adapting any index here is ok, we take hnsw for example
PSQL_BASE -c "create index hnsw_recipe1m on Recipe using hnsw(image_embedding hnsw_vector_inner_product_ops) with (dimension='1024', distmethod=inner_product);"
PSQL_ESTI -c "create index hnsw_recipe1m on Recipe using hnsw(image_embedding hnsw_vector_inner_product_ops) with (dimension='1024', distmethod=inner_product);"
PSQL_BASE -c "create index bt_recipe1m_scalar on Recipe_scalar(popularity);"
PSQL_ESTI -c "create index bt_recipe1m_scalar on Recipe_scalar(popularity);"
cd $WORKDIR