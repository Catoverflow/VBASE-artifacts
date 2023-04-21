#!/usr/bin/zsh
# We didn't control random seed when evaluating in the first place, 
# so there may be minor fluctuations in the results.

# pip3 install -r requirements.txt 2> /dev/null

DBNAME=planning_test
DBUSERNAME=vectordb
DBPASSWORD=vectordb
ADDR=localhost
PORT=15432
PORT_ESTI=25432
alias PSQL_BASE="PGPASSWORD=$DBPASSWORD psql -U $DBUSERNAME -d $DBNAME -h $ADDR -p $PORT"
alias PSQL_ESTI="PGPASSWORD=$DBPASSWORD psql -U $DBUSERNAME -d $DBNAME -h $ADDR -p $PORT_ESTI"
WORKDIR=$(pwd)
cd ../planning
python3 generate_sql.py
echo "Querying with fixed range and changing popularity on btree-indexed table...(1/5)"
PSQL_ESTI -f tmp/bt_fix_r_esti.sql | grep Aggre | grep -oE "=[0-9]+\.[0-9]+" | cut -d= -f 2 > cache/bt_fix_r_esti.txt
PSQL_BASE -f tmp/bt_fix_r_exec.sql | grep Time | grep -oE "[0-9]+\.[0-9]+ ms" | cut -d\  -f 1 > cache/bt_fix_r_exec.txt
echo "Querying with fixed popularity and changing range on btree-indexed table...(2/5)"
PSQL_ESTI -f tmp/bt_fix_p_esti.sql |  grep Aggre | grep -oE "=[0-9]+\.[0-9]+" | cut -d= -f 2 > cache/bt_fix_p_esti.txt
PSQL_BASE -f tmp/bt_fix_p_exec.sql | grep Time | grep -oE "[0-9]+\.[0-9]+ ms" | cut -d\  -f 1 > cache/bt_fix_p_exec.txt
echo "Querying with fixed range and changing popularity on hnsw-indexed table...(3/5)"
PSQL_ESTI -f tmp/hnsw_fix_r_esti.sql | grep Aggre | grep -oE "=[0-9]+\.[0-9]+" | cut -d= -f 2 > cache/hnsw_fix_r_esti.txt
PSQL_BASE -f tmp/hnsw_fix_r_exec.sql | grep Time | grep -oE "[0-9]+\.[0-9]+ ms" | cut -d\  -f 1 > cache/hnsw_fix_r_exec.txt
echo "Querying with fixed popularity and changing range on hnsw-indexed table...(4/5)"
PSQL_ESTI -f tmp/hnsw_fix_p_esti.sql | grep Aggre | grep -oE "=[0-9]+\.[0-9]+" | cut -d= -f 2 > cache/hnsw_fix_p_esti.txt
PSQL_BASE -f tmp/hnsw_fix_p_exec.sql | grep Time  | grep -oE "[0-9]+\.[0-9]+ ms" | cut -d\  -f 1 > cache/hnsw_fix_p_exec.txt
echo "Gathering selectivity ground truth of varing r...(5/5)"
PSQL_BASE -f tmp/gather_sel.sql | grep count | cut -f 3 -d\  > cache/gt_cardinality.txt
PSQL_BASE -f tmp/gather_sel_fix_r.sql | grep count | cut -f 3 -d\  > cache/gt_cardinality_fix_r.txt
python3 planning.py
rm -f "./tmp/*"
cd $WORKDIR