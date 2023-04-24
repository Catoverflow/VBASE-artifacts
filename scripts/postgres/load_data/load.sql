create database postgres_db;
\c postgres_db;
create extension vectordb;

create table recipe_table(id int PRIMARY KEY, image_embedding float8[1024], text_embedding float8[1024], description text, popularity int);
alter table recipe_table alter image_embedding  set storage plain;
alter table recipe_table alter text_embedding  set storage plain;
alter table recipe_table alter description set storage plain;

copy recipe_table from '/artifacts/scripts/data_prepare/data_source.tsv' DELIMITER E'\t' csv quote e'\x01';

create index bindex on recipe_table(popularity);

create table tag_table(id int PRIMARY KEY,image_embedding float8[1024]);
copy tag_table from '/artifacts/scripts/data_prepare/tag_datasource.tsv' DELIMITER E'\t' csv quote e'\x01';
