import { Client } from "pg";
import { add, complete, cycle, save, suite } from "benny"
const pgvector = require('pgvector/pg');
import { range } from 'lodash';
import { SingleBar } from 'cli-progress'

const DATASET_SIZE = Number.parseInt(process.argv[2]); // 1_000;
const DATASET_DIMS = Number.parseInt(process.argv[3]); // 8;

const make_vec = () => pgvector.toSql(range(0, DATASET_DIMS).map(_ => Math.random() * 10));

const main = async () => {
    const client = new Client('postgres://jupyter:jupyter@localhost/postgres')
    await client.connect()
    console.log('connected')
    await pgvector.registerType(client);
    console.log('plugin registered')
    await client.query("DROP TABLE IF EXISTS test;");
    await client.query(`CREATE TABLE test
    (
        id SERIAL,
        vec VECTOR(${DATASET_DIMS}),
        sca INT,
        PRIMARY KEY (id)
    );`);
    console.log('table created')
    const bar1 = new SingleBar({});
    bar1.start(DATASET_SIZE, 0);
    for (let i = 0; i < DATASET_SIZE; i++) {
        await client.query("INSERT INTO test (vec, sca) VALUES ($1, $2);",
            [make_vec(), Math.round(Math.random() * 100)]);
        bar1.increment();
    }
    bar1.stop();

    const query = `SELECT *, (vec <-> $1) AS dist
    FROM test
    ORDER BY vec <-> $1
    LIMIT 5;`;
    const origin = make_vec();

    await suite(
        /**
         * Name of the suite - required
         */
        "pgvector",

        /**
         * If the code that you want to benchmark has no setup,
         * you can run it directly:
         */
        add('without index', async () => {
            await client.query(query, [origin])
        }),

        /**
         * If the code that you want to benchmark requires setup,
         * you should return it wrapped in a function:
         */
        add('with index', async () => {
            // setup
            await client.query('CREATE INDEX ON test USING ivfflat (vec);')
            // benched
            return async () => {
                await client.query(query, [origin])
            }
        }),
        cycle(),
        complete(),
        save({
            file: `pgvector-${DATASET_SIZE}-${DATASET_DIMS}`
        }),
    )

    await client.end()
}

main().then(console.log).catch(console.error);

