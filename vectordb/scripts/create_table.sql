create database test_db;
\c test_db;
create extension if not exists vector;
create extension if not exists vectordb;

create table d_table(id int PRIMARY KEY,image_embedding double precision[1024],text_embedding double precision[1024],content text,ingre_count int,instr_step int);
alter table d_table alter image_embedding set storage plain;
alter table d_table alter text_embedding set storage plain;
alter table d_table alter content set storage plain;
copy d_table from '/vectordb/data.tsv' DELIMITER E'\t' csv quote e'\x01';

create index hnsw_index1 on d_table using hnsw(image_embedding hnsw_vector_inner_product_ops) with (dimension='1024', distmethod=inner_product);
create index hnsw_index2 on d_table using hnsw(text_embedding hnsw_vector_inner_product_ops) WITH (dimension='1024', distmethod=inner_product);

\d d_table