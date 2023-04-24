from tabulate import tabulate
from tqdm import tqdm
import argparse
import numpy as np

parser = argparse.ArgumentParser()
parser.add_argument('--sample', type=str, default='../planning/cache/datasource_1col_sample.tsv', help='path to sample table')
parser.add_argument('--full', type=str, default='../data_prepare/data_source.tsv', help='path to full table')
args = parser.parse_args()

# the approximate upper and lower bound of r depends on dataset
rlist_qerr = [round(r/100,2) for r in range(90,180,3)]
query_vecs = []
fsample = None
fsample = open(args.sample, 'r')
for line in fsample:
    line = np.fromstring(line.strip()[1:-1], dtype=float, sep=',')
    query_vecs.append(line)
fsample.close()
full_vecs = []
sample_vecs = []
SAMPLE_RATE = 0.001
print("Reading full table...")
print(f"Sample rate = {SAMPLE_RATE}")


ffull = open(args.full,'r')
for line in tqdm(ffull,total=330922):
    line=line.strip().split('}')[0].split('{')[1]
    line = np.fromstring(line, dtype=float, sep=',')
    full_vecs.append(line)
    if np.random.rand() < SAMPLE_RATE:
        sample_vecs.append(line)
ffull.close()
print("Querying for ground truth...")
gt_table = []
for query in tqdm(query_vecs):
    dist_table = sorted([np.linalg.norm(query-vec) for vec in full_vecs])
    card_table = []
    j = 0
    for i in range(len(dist_table)):
        while j < len(rlist_qerr) and dist_table[i] > rlist_qerr[j]:
            card_table.append(i)
            j += 1
        if j == len(rlist_qerr):
            break
    gt = [card/len(dist_table) for card in card_table]
    if len(gt) < len(rlist_qerr):
        gt += [1.0] * (len(rlist_qerr) - len(gt))
    gt_table.extend(gt)
esti_table = []
for query in query_vecs:
    dist_table = sorted([np.linalg.norm(query-vec) for vec in sample_vecs])
    card_table = []
    j = 0
    for i in range(len(dist_table)):
        while j < len(rlist_qerr) and dist_table[i] > rlist_qerr[j]:
            card_table.append(i)
            j += 1
        if j == len(rlist_qerr):
            break
    esti = [card/len(dist_table) for card in card_table]
    if len(esti) < len(rlist_qerr):
        esti += [1.0] * (len(rlist_qerr) - len(esti))
    esti_table.extend(esti)
# bucket center: round(selec - 0.05, 1) + 0.05
bucket = {}
for real_selec, esti_selec in zip(gt_table, esti_table):
    bucket_center = round(real_selec - 0.05, 1) + 0.05
    if real_selec == 0 or esti_selec == 0:
        qerror = float('inf') if real_selec == esti_selec else 1
    else:
        qerror = real_selec / esti_selec if real_selec > esti_selec else esti_selec / real_selec
    if bucket_center not in bucket:
        bucket[bucket_center] = [qerror]
    else:
        bucket[bucket_center].append(qerror)

bucket_centers = sorted(bucket.keys())
for bucket_center in bucket_centers:
    # remove buckets that is not big enough
    if len(bucket[bucket_center]) < 100:
        bucket.pop(bucket_center)
# print box plot:
bucket_centers = sorted(bucket.keys())
for b in bucket.keys():
    bucket[b] = sorted(bucket[b])

Q1 = np.array([bucket[b][round((len(bucket[b])+1)/4)-1] for b in bucket_centers])
Q3 = np.array([bucket[b][round((len(bucket[b])+1)/4*3)-1] for b in bucket_centers])
median = np.array([bucket[b][round((len(bucket[b])+1)/2)-1] for b in bucket_centers])
IQR = Q3 - Q1
table = \
{
    "Selectivity (rounded)": [round(center,2) for center in bucket_centers],
    "Q1-1.5IQR": np.fmax(Q1-1.5*IQR, np.ones(Q1.shape[0])),
    "Q1": Q1,
    "median": median,
    "Q3": Q3,
    "Q3+1.5IQR": Q3+1.5*IQR, 
    "Count": [len(bucket[b]) for b in bucket_centers]
}
# I don't get it why "inf"'s default alignment follow str's style, as it's a valid float
# and it's affected by numalign param
table="Figure 6: Q-error in different selectivity\n" + tabulate(table, headers="keys", numalign="right")
print(table)
with open("../planning/QError.log",'w') as fout:
    fout.write(table)
    fout.close()
print(f"Saved to planning/QError.log")
