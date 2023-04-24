\c test_db;

CREATE TABLE d_table_sptag AS TABLE d_table;

ALTER TABLE d_table_sptag ADD PRIMARY KEY(id);

create index sptag_index1 on d_table_sptag using sptag(text_embedding vector_inner_product_ops) with(threads=16, distmethod=inner_product);
create index sptag_index2 on d_table_sptag using sptag(image_embedding vector_inner_product_ops) with(threads=16, distmethod=inner_product);

\d d_table_sptag