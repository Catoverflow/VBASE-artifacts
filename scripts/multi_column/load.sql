create database test_db;
\c test_db;

CREATE EXTENSION vectordb;

create table d_table(id int PRIMARY KEY, image_embedding float8[1024], text_embedding float8[1024], description text, popularity int);
alter table d_table alter image_embedding  set storage plain;
alter table d_table alter text_embedding  set storage plain;
alter table d_table alter description set storage plain;

copy d_table from '/artifacts/scripts/data_prepare/data_source.tsv' DELIMITER E'\t' csv quote e'\x01';

create index image_hnsw_index on d_table using hnsw(image_embedding hnsw_vector_inner_product_ops) with(dimension=1024, distmethod=inner_product);
create index text_hnsw_index on d_table using hnsw(text_embedding hnsw_vector_inner_product_ops) with(dimension=1024, distmethod=inner_product);
