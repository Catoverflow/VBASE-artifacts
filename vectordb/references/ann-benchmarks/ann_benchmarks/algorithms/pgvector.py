from pgvector.psycopg2 import register_vector
import psycopg2
import psycopg2.extras
import sklearn
import numpy
from ann_benchmarks.algorithms.base import BaseANN


class PgVector(BaseANN):
    def __init__(self, metric, lists):
        self._lists = lists
        self._probes = None
        self._metric = metric
        self._postgres = psycopg2.connect(
            'host=127.0.0.1 dbname=postgres user=bench password=bench')
        register_vector(self._postgres)

    def fit(self, X):
        # if self._metric == 'angular':
        #     X = sklearn.preprocessing.normalize(X, axis=1, norm='l2')

        cur = self._postgres.cursor()
        cur.execute('DROP TABLE IF EXISTS test;')
        cur.execute(
            'CREATE TABLE test (id SERIAL, vec VECTOR(%s), PRIMARY KEY (id));', (X.shape[1],))
        vectors = [(v,) for v in X.tolist()]
        psycopg2.extras.execute_values(
            cur, 'INSERT INTO test (vec) VALUES %s;', vectors)

        if self._metric == 'euclidean':
            cur.execute('CREATE INDEX ON test USING ivfflat (vec);')
        elif self._metric == 'angular':
            cur.execute(
                'CREATE INDEX ON test USING ivfflat (vec vector_cosine_ops);')
        elif self._metric == 'dot':
            cur.execute(
                'CREATE INDEX ON test USING ivfflat (vec vector_ip_ops);')
        else:
            print('warning! unknown metric:', self._metric)


    def set_query_arguments(self, probes):
        if probes > self._lists:
            print('warning! nprobe > nlist')
            probes = self._lists
        self._probes = probes
        cur = self._postgres.cursor()
        cur.execute(f'SET ivfflat.probes = {probes};')

    def query(self, v, n):
        # if self._metric == 'angular':
        #     v /= numpy.linalg.norm(v)
        cur = self._postgres.cursor()
        vec = numpy.array(v.tolist())
        if self._metric == 'euclidean':
            psycopg2.extras.execute_values(
                cur, 'SELECT id FROM test ORDER BY vec <-> %s LIMIT {};'.format(n), [(vec,)])
        elif self._metric == 'angular':
            psycopg2.extras.execute_values(
                cur, 'SELECT id FROM test ORDER BY vec <=> %s LIMIT {};'.format(n), [(vec,)])
        elif self._metric == 'dot':
            psycopg2.extras.execute_values(
                cur, 'SELECT id FROM test ORDER BY vec <#> %s LIMIT {};'.format(n), [(vec,)])
        else:
            print('warning! unknown metric:', self._metric)

        return [id - 1 for (id,) in cur.fetchall()]

    def __str__(self):
        return 'PgVector(nlist=%d, nprobe=%d)' % (self._lists, self._probes)
