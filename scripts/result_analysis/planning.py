from tabulate import tabulate
import numpy as np

R_LIST_LEN=14
P_LIST_LEN=14
THREASHOLD=0.025
# fix popularity change range part
fbt_fix_p_exec = open('../planning/cache/bt_fix_p_exec.txt','r')
fbt_fix_p_esti = open('../planning/cache/bt_fix_p_esti.txt','r')
fhnsw_fix_p_exec = open('../planning/cache/hnsw_fix_p_exec.txt','r')
fhnsw_fix_p_esti = open('../planning/cache/hnsw_fix_p_esti.txt','r')
fr_sel = open('../planning/cache/gt_cardinality.txt')

def collect_gt_sel(USE_CACHE):
    ffull = open('./datasource_1col.tsv','r')
    if USE_CACHE:
        fsample = open('./cache/datasource_1col_sample.tsv', 'r')
    else:
        fsample = open('./tmp/datasource_1col_sample.tsv', 'r')
    full_vecs = []
    query_vecs = []
    for line in ffull:
        line = np.fromstring(line.strip()[1:-1], dtype=float, sep=',')
        full_vecs.append(line)
    for line in fsample:
        line = np.fromstring(line.strip()[1:-1], dtype=float, sep=',')
        query_vecs.append(line)
    ffull.close()
    fsample.close()
    gt_table = []
    rlist_plan = [.25,.55,.70,.78,.84,.88,.92,.955,.98,1.005,1.02,1.04,1.06,1.075]
    FIX_R=0.77
    for query in query_vecs:
        dist_table = sorted([np.linalg.norm(query-vec) for vec in full_vecs])
        card_table = []
        j = 0
        for i in range(len(dist_table)):
            while j < len(rlist_plan) and dist_table[i] > rlist_plan[j]:
                card_table.append(i)
                j += 1
            if j == len(rlist_plan):
                break
        gt = [card/len(dist_table) for card in card_table]
        if len(gt) < len(rlist_plan):
            gt += [1.0] * (len(rlist_plan) - len(gt))
        gt_table.extend(gt)
    # pass


# data format:
# data[r0, ..., r_{R_LIST_LEN}][p0, ..., p_{sample_max}]
bt_exec = [[] for i in range(R_LIST_LEN)]
bt_esti = [[] for i in range(R_LIST_LEN)]
hnsw_exec = [[] for i in range(R_LIST_LEN)]
hnsw_esti = [[] for i in range(R_LIST_LEN)]
q_r_sel = [[] for i in range(R_LIST_LEN)]
cnt = 0
for line_bt_exec,line_bt_esti,line_hnsw_exec,line_hnsw_esti,line_sel in zip(fbt_fix_p_exec,fbt_fix_p_esti,fhnsw_fix_p_exec,fhnsw_fix_p_esti,fr_sel):
    bt_esti[cnt].append(float(line_bt_esti.strip()))
    hnsw_esti[cnt].append(float(line_hnsw_esti.strip()))
    bt_exec[cnt].append(float(line_bt_exec.strip()))
    hnsw_exec[cnt].append(float(line_hnsw_exec.strip()))
    q_r_sel[cnt].append(int(line_sel.strip())/330922)
    cnt = (cnt+1) % R_LIST_LEN

fbt_fix_p_exec.close()
fhnsw_fix_p_exec.close()
fr_sel.close()

## plotting first graph
# bucket center = 0.05,0.10,...,0.45
print("Plotting plan cost when popularity is fixed and range is variable...")
bt_cost = [[] for i in range(R_LIST_LEN)]
hnsw_cost = [[] for i in range(R_LIST_LEN)]
vecdb_cost = [[] for i in range(R_LIST_LEN)]
for r_sel, r_hnsw_exec, r_hnsw_esti, r_bt_exec, r_bt_esti in zip(q_r_sel, hnsw_exec, hnsw_esti, bt_exec, bt_esti):
    for q_sel, q_hnsw_exec, q_hnsw_esti, q_bt_exec, q_bt_esti in zip(r_sel, r_hnsw_exec, r_hnsw_esti, r_bt_exec, r_bt_esti):
        # get nearest bucket center
        bkt_center = round(q_sel * 20) # 0.05, ... , 0.50
        if abs(bkt_center/20 - q_sel) > THREASHOLD:
            continue
        if bkt_center > R_LIST_LEN or bkt_center <= 0:
            continue
        bkt_center -= 1 # 1-10 -> 0-9
        hnsw_cost[bkt_center].append(q_hnsw_exec)
        bt_cost[bkt_center].append(q_bt_exec)
        vecdb_cost[bkt_center].append(q_hnsw_exec if q_hnsw_esti < q_bt_esti else q_bt_exec)
fix_p_table = {
    "Selectivity(range)": [round(r/20,2) for r in range(1,11)],
    "BTree Scan(Default)": [np.mean(bt_cost[r]) for r in range(10)],
    "HNSW Scan": [np.mean(hnsw_cost[r]) for r in range(10)],
    "Vector DB": [np.mean(vecdb_cost[r]) for r in range(10)],
    "Count": [len(bt_cost[r]) for r in range(10)]
}
fix_p_table = "Execution time when selectivity of popularity is fixed to 0.9\n" +\
    tabulate(fix_p_table, headers="keys")
print(fix_p_table)
flog = open("../planning/planning.log","w")
flog.write(fix_p_table + '\n')
print("Table saved to planning/planning.log")
# fix range change popuarity part
bt_exec = [[] for i in range(P_LIST_LEN)]
bt_esti = [[] for i in range(P_LIST_LEN)]
hnsw_exec = [[] for i in range(P_LIST_LEN)]
hnsw_esti = [[] for i in range(P_LIST_LEN)]
fbt_fix_r_exec = open('../planning/cache/bt_fix_r_exec.txt','r')
fbt_fix_r_esti = open('../planning/cache/bt_fix_r_esti.txt','r')
fhnsw_fix_r_exec = open('../planning/cache/hnsw_fix_r_exec.txt','r')
fhnsw_fix_r_esti = open('../planning/cache/hnsw_fix_r_esti.txt','r')
ffix_r_sel = open('../planning/cache/gt_cardinality_fix_r.txt')
cnt = 0
for line_bt_exec,line_bt_esti, line_hnsw_exec,line_hnsw_esti in zip(fbt_fix_r_exec,fbt_fix_r_esti, fhnsw_fix_r_exec,fhnsw_fix_r_esti):
    bt_exec[cnt].append(float(line_bt_exec.strip()))
    hnsw_exec[cnt].append(float(line_hnsw_exec.strip()))
    bt_esti[cnt].append(float(line_bt_esti.strip()))
    hnsw_esti[cnt].append(float(line_hnsw_esti.strip()))
    cnt = (cnt+1) % P_LIST_LEN
# find the most common selectivity of r
q_r_sel_fix = [int(line.strip())/330922 for line in ffix_r_sel]
# common_r_sel = np.mean(q_r_sel_fix)
common_r_sel = 0.13 # paper's data

ffix_r_sel.close()
fbt_fix_r_exec.close()
fhnsw_fix_r_exec.close()


bt_cost = [[] for i in range(P_LIST_LEN)]
hnsw_cost = [[] for i in range(P_LIST_LEN)]
vecdb_cost = [[] for i in range(P_LIST_LEN)]

for q_sel, p in zip(q_r_sel_fix, range(len(q_r_sel_fix))):
    if abs(q_sel - common_r_sel) > 0.2:
        continue
    for i in range(P_LIST_LEN):
        bt_cost[i].append(bt_exec[i][p])
        hnsw_cost[i].append(hnsw_exec[i][p])
        vecdb_cost[i].append(hnsw_exec[i][p] if hnsw_esti[i][p] < bt_esti[i][p] else bt_exec[i][p])

cut_index = 9 # in paper we only plot till selectivity = 0.5, here we have extra data
assert cut_index <= P_LIST_LEN
bt_cost = bt_cost[:cut_index]
hnsw_cost = hnsw_cost[:cut_index]
vecdb_cost = vecdb_cost[:cut_index]
fix_r_table = {
    "Selectivity(popularity)": [round((20000+20000*i)/330922, 2) for i in range(14)][:cut_index],
    "BTree Scan(Default)": [np.mean(bt_cost[i]) for i in range(cut_index)],
    "HNSW Scan": [np.mean(hnsw_cost)]*cut_index,
    "Vector DB": [np.mean(vecdb_cost[i]) for i in range(cut_index)],
    "Count": [len(bt_cost[i]) for i in range(cut_index)]
}
fix_r_table = "Execution time when selectivity of range query is fixed to 0.13\n" +\
    tabulate(fix_r_table, headers="keys")
print(fix_r_table)
flog.write(fix_r_table)
print("Table saved to planning/planning.log")