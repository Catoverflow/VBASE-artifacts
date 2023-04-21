create database pase_db;
\c pase_db;

CREATE EXTENSION vectordb;

create table recipe_table(id int PRIMARY KEY, image_embedding float8[1024], text_embedding float8[1024], description text, popularity int, bm25 jsonb);
-- alter table recipe_table alter image_embedding  set storage plain;
-- alter table recipe_table alter text_embedding  set storage plain;
-- alter table recipe_table alter description set storage plain;
-- alter table recipe_table alter bm25 set storage plain;
copy recipe_table from '/artifacts/scripts/data_prepare/data_source.tsv' DELIMITER E'\t' csv quote e'\x01';

create index pase_image_hnsw_index on recipe_table using pase_hnsw(image_embedding pase_hnsw_vector_inner_product_ops) with(dimension=1024, distmethod=inner_product);

create index bindex on recipe_table(popularity);
