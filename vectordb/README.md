# VectorDB

## Requirements

- swig >= 3.0
- cmake >= 3.14.0
- boost >= 1.67.0


## How to run tests

Add yourself to docker group first

```bash
usermod -a -G docker $(id -nu)
```

Clone submodules

```bash
git submodule update --init --recursive
```

### Build docker image

```bash
./tests/dockerbuild.sh
```

> Building from source may take a long time

### Run vectordb container

```bash
./tests/dockerrun.sh
```

### Perform SQL execution and testing

Connect to psql:

> Change the ip from localhost to your remote server ip if it's the case 

```bash
psql -h localhost -p 15432 -d vectordb -U vectordb
```

Perform tests:

```sql
create database test_db;
\c test_db;
create extension vectordb;
insert into model values ('word2vec', 'word2vec', '0');
select inference('word2vec', 'some random text');
CREATE EXTENSION vector;
create table t_table(id int, mat char(100), m_vector_1 float8[100], m_vector_2 vector(100));
insert into t_table values(1, 'nylon', inference('word2vec','nylon'), inference('word2vec','nylon'));
insert into t_table values(2, 'mylon', inference('word2vec','mylon'),inference('word2vec','mylon'));
insert into t_table values(5, 'aylon', inference('word2vec','aylon'),inference('word2vec','aylon'));
insert into t_table values(10, 'bffdasf', inference('word2vec','bffdasf'),inference('word2vec','bffdasf'));
create index t1_index on t_table using sptag(m_vector_1);
create index t2_index on t_table using ivfflat(m_vector_2);
set enable_seqscan=false;
select * from t_table order by m_vector_2 <-> inference('word2vec','nylon') limit 1;
select * from t_table order by m_vector_1 <-> inference('word2vec','nylon') limit 2;

select * from t_table order by (m_vector_1 <-> inference('word2vec','nylon')) + (m_vector_2 <-> inference('word2vec','nylon')) limit 2;
select multicol_topk('t_table', 2, '', '', 'm_vector_1 <-> inference(''word2vec'', ''nylon'')', 'm_vector_2 <-> inference(''word2vec'', ''nylon'')');
select * from t_table where id < 8 order by (m_vector_1 <-> inference('word2vec','nylon')) + (m_vector_2 <-> inference('word2vec','nylon')) limit 2;
select multicol_topk('t_table', 2, 'id < 8', '', 'm_vector_1 <-> inference(''word2vec'', ''nylon'')', 'm_vector_2 <-> inference(''word2vec'', ''nylon'')');

# index create with parameter
# sptag have parameter "threads" which between 1 to 16 and "distmethod" whose values are "inner_product" and "l2_distance"
create index t3_index on t_table using sptag(m_vector_1 vector_inner_product_ops) with(threads=16,distmethod=inner_product);
# hnsw have parameter "dimension" which between 1 to 4096 and "distmethod" whose values are "inner_product" and "l2_distance"
create index t4_index on t_table using hnsw(m_vector_1) with(dimension=1024,distmethod=l2_distance);
```

### Discard vectordb container

Stop:

```bash
docker stop vectordb
```

Delete:

```bash
docker rm vectordb
```

## Structure

`CMakeLists.txt` is responsible for building the project, including installing extension. To add version upgrade SQL, please refer to L14. To add new source codes, please add it in L46.

`sql/vectordb.sql` defines extension installation SQL, which introduces data types, operators and indices.

`src/index.cpp` defines the `IndexAmRoutine` functions and relative functions (like `ambuildindex`).

### Tips

Because PostgreSQL headers do not have C++ support, so the `#include` directives must be wrapped in an `extern "C"` block.

For introducing new PostgreSQL functions, use `CPP_PG_FUNCTION_INFO_V1` in `src/util.hpp`.

The function pointers returned by PostgreSQL functions must be defined as `extern "C"`.

## References

- [pg_cmake_template](https://github.com/jwdeitch/pg_cmake_template/blob/master/CMakeLists.txt)
- [pgvector](https://github.com/ankane/pgvector) with CMake support, see `references/pgvector`
- [ann-benchmarks](http://ann-benchmarks.com/) with pgvector support, see `references/ann-benchmarks`
