# VBASE-artifacts
Artifacts for VBASE: Unifying Online Vector Similarity Search and Relational Queries via Relaxed Monotonicity

We use Docker to conduct the experimental process, including environment installation, data downloading, data importing, running queries, and result analysis.

## Evaluation
1. Environment prepare: build docker image and run

`
./scripts/env_prepare/create_vbase_docker.sh
`

2. Data Prepare: download data set and cook data

`
./scripts/data_prepare/data_prepare.sh
`

3. Data loading

`
./scripts/data_prepare/load_data.sh
`

4. Run Experiments

`
./scripts/run_experiments/run.sh
`

5. You can also run experment one by one

`
./scripts/run_experiments/run_table_5.sh
`

<img width="1039" alt="table5" src="https://user-images.githubusercontent.com/3930308/233872755-9532baec-a232-44b6-8150-40e6841ff86c.PNG">

*Conducting all query tests without using vector index on PostgreSQL(first row in Table-5) would take approximately one week. Therefore, we are presenting the previous results and also running a sample of 100 queries for each query type (there may be some sampling error in the results). If you need to run the complete statements, you can uncomment this section in ./scripts/run_experiments/run_table_5.sh.*

`
./scripts/run_experiments/run_table_6.sh
`

<img width="1057" alt="table6" src="https://user-images.githubusercontent.com/3930308/233872770-7626f7e3-5b23-4492-aa0d-0fbd6497234d.PNG">

`
./scripts/run_experiments/run_table_7.sh
`

<img width="521" alt="table7" src="https://user-images.githubusercontent.com/3930308/233872786-61ec1500-aa98-4b01-b683-0971ca613d3f.PNG">

`
./scripts/run_experiments/run_table_8.sh
`

<img width="518" alt="table8" src="https://user-images.githubusercontent.com/3930308/233872798-13bbe4f2-f36a-44a4-8b98-dbfcda5d624e.PNG">

`
./scripts/run_experiments/run_fig_6.sh
`

<img width="517" alt="figure6" src="https://user-images.githubusercontent.com/3930308/233813396-b391735e-4fec-4c3e-82d6-40ea2d771830.PNG">

`
./scripts/run_experiments/run_fig_7.sh
`

<img width="522" alt="figure7" src="https://user-images.githubusercontent.com/3930308/233813403-69eadc48-d5f6-4443-8f8a-636a319c20a9.PNG">
