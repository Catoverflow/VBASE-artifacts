#!/usr/bin/zsh
# We didn't control random seed when evaluating in the first place, 
# so there may be minor fluctuations in the results.

# pip3 install -r requirements.txt 2> /dev/null

(cd ../planning && python3 generate_sql.py)
echo "Querying with fixed range and changing popularity on btree-indexed table...(1/5)"
docker exec vbase_planning_esti bash -c "psql -d planning_test -f /planning/tmp/bt_fix_r_esti.sql | grep Aggre | grep -oE '=[0-9]+\.[0-9]+' | cut -d= -f 2 > /planning/cache/bt_fix_r_esti.txt"
docker exec vbase_planning_exec bash -c "psql -d planning_test -f /planning/tmp/bt_fix_r_exec.sql | grep Time | grep -oE '[0-9]+\.[0-9]+ ms' | cut -d\  -f 1 > /planning/cache/bt_fix_r_exec.txt"
echo "Querying with fixed popularity and changing range on btree-indexed table...(2/5)"
docker exec vbase_planning_esti bash -c "psql -d planning_test -f /planning/tmp/bt_fix_p_esti.sql | grep Aggre | grep -oE '=[0-9]+\.[0-9]+' | cut -d= -f 2 > /planning/cache/bt_fix_p_esti.txt"
docker exec vbase_planning_exec bash -c "psql -d planning_test -f /planning/tmp/bt_fix_p_exec.sql | grep Time | grep -oE '[0-9]+\.[0-9]+ ms' | cut -d\  -f 1 > /planning/cache/bt_fix_p_exec.txt"
echo "Querying with fixed range and changing popularity on hnsw-indexed table...(3/5)"
docker exec vbase_planning_esti bash -c "psql -d planning_test -f /planning/tmp/hnsw_fix_r_esti.sql | grep Aggre | grep -oE '=[0-9]+\.[0-9]+' | cut -d= -f 2 > /planning/cache/hnsw_fix_r_esti.txt"
docker exec vbase_planning_exec bash -c "psql -d planning_test -f /planning/tmp/hnsw_fix_r_exec.sql | grep Time | grep -oE '[0-9]+\.[0-9]+ ms' | cut -d\  -f 1 > /planning/cache/hnsw_fix_r_exec.txt"
echo "Querying with fixed popularity and changing range on hnsw-indexed table...(4/5)"
docker exec vbase_planning_esti bash -c "psql -d planning_test -f /planning/tmp/hnsw_fix_p_esti.sql | grep Aggre | grep -oE '=[0-9]+\.[0-9]+' | cut -d= -f 2 > /planning/cache/hnsw_fix_p_esti.txt"
docker exec vbase_planning_exec bash -c "psql -d planning_test -f /planning/tmp/hnsw_fix_p_exec.sql | grep Time | grep -oE '[0-9]+\.[0-9]+ ms' | cut -d\  -f 1 > /planning/cache/hnsw_fix_p_exec.txt"
echo "Gathering selectivity ground truth of varing r...(5/5)"
docker exec vbase_planning_esti bash -c "psql -d planning_test -f /planning/tmp/gather_sel.sql | grep count | cut -f 3 -d\  > /planning/cache/gt_cardinality.txt"
docker exec vbase_planning_esti bash -c "psql -d planning_test -f /planning/tmp/gather_sel_fix_r.sql | grep count | cut -f 3 -d\  > /planning/cache/gt_cardinality_fix_r.txt"
