-- creat new database
create database vector_demo;
-- switch to demo database
\c vector_demo;
create extension if not exists vector;
create extension if not exists vectordb;
insert into model values ('word2vec', 'word2vec', '0');
create table vector_table(id int, material char(100), material_vector vector(100), vendor char(100), vendor_vector vector(100), cost int);
insert into vector_table values(1,'cotton',inference('word2vec', 'cotton'), 'nike',inference('word2vec', 'nike'), 100);
insert into vector_table values(2,'nylon', inference('word2vec', 'nylon'),  'adidas',inference('word2vec', 'adidas'), 150);
insert into vector_table values(3,'silk',  inference('word2vec', 'silk'),  'adidas',inference('word2vec', 'adidas'), 150);
insert into vector_table values(4,'silk',  inference('word2vec', 'silk'),  'lining',inference('word2vec', 'lining'), 120);
    
CREATE INDEX ON vector_table USING ivfflat(material_vector);
CREATE INDEX ON vector_table USING ivfflat(vendor_vector);
CREATE INDEX ON vector_table(cost);
-- show table
\d vector_table;

select id from vector_table order by (material_vector <-> inference('word2vec', 'new nylon')) + (vendor_vector <-> inference('word2vec', 'adddidas')) limit 3;
 -- the fifth arg is left as empty string such that there is no filter expression
 -- the sixth arg is left as empty string to use default ranking expression by summation
select multicol_topk('vector_table', 3, 0, 'id', '', '', 'vendor_vector <-> inference(''word2vec'', ''adddidas'')', 'material_vector <-> inference(''word2vec'', ''new nylon'')');
select multicol_topk('vector_table', 3, 0, 'id', '', '', 'material_vector <-> inference(''word2vec'', ''new nylon'')', 'vendor_vector <-> inference(''word2vec'', ''adddidas'')');