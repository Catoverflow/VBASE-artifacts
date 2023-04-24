# Because distribution of range query selectivity is not even on r,
# by curve fitting we can calaulate corresponding r of specific selectivity
# you can also use uniform r to avoid this, but it will take much more time
# to have enough sample in bucket which is not popular enough

import argparse

parser = argparse.ArgumentParser()
parser.add_argument('--sample', type=str, default='cache/datasource_1col_sample.tsv', help='full dataset')
args = parser.parse_args()

# range are picked according to cost pivot, 
# i.e. the point that Postgres switch plan falls into the centers of these ranges
# approxmately sel(r) ~ [0.05, 0.45]
rlist_plan = [.25,.55,.70,.78,.84,.88,.92,.955,.98,1.005,1.02,1.04,1.06,1.075]
plist_plan = [20000+20000*i for i in range(14)]

fsample = open(args.sample, 'r')
fbt_fix_r_esti = open('./tmp/bt_fix_r_esti.sql','w')
fhnsw_fix_r_esti = open('./tmp/hnsw_fix_r_esti.sql','w')
fbt_fix_popularity_esti = open('./tmp/bt_fix_p_esti.sql','w')
fhnsw_fix_popularity_esti = open('./tmp/hnsw_fix_p_esti.sql','w')
fbt_fix_r_exec = open('./tmp/bt_fix_r_exec.sql','w')
fhnsw_fix_r_exec = open('./tmp/hnsw_fix_r_exec.sql','w')
fbt_fix_popularity_exec = open('./tmp/bt_fix_p_exec.sql','w')
fhnsw_fix_popularity_exec = open('./tmp/hnsw_fix_p_exec.sql','w')
fgather_selectivity_of_r = open('./tmp/gather_sel.sql','w')
fgather_selectivity_of_fix_r = open('./tmp/gather_sel_fix_r.sql','w')

OPT="set max_parallel_workers_per_gather=0;set enable_seqscan=false;set seq_page_cost=15.6;set random_page_cost=15.6;\n"
# set enable_bitmapscan=off; 
SIZE=330922 # = wc -l ./tmp/datasource_1col.tsv, number of vectors in file
Q_WARMUP = ""
FIX_P=int(0.9*330922)
# Actually the r satisfying sel(r) = 0.12 varies on embeddings, 
# and is filtered by the result of tmp/gather_sel.sql
# the R here only makes sure distance calculation is performed
FIX_R=0.77

for sample in fsample:
    sample = sample.strip()[1:-1] # strip {}
    if Q_WARMUP == "":
        fbt_fix_r_esti.write(OPT)
        fbt_fix_popularity_esti.write(OPT)
        fhnsw_fix_r_esti.write(OPT)
        fhnsw_fix_popularity_esti.write(OPT)
        fbt_fix_r_exec.write(OPT)
        fbt_fix_popularity_exec.write(OPT)
        fhnsw_fix_r_exec.write(OPT)
        fhnsw_fix_popularity_exec.write(OPT)
        fgather_selectivity_of_r.write("\\x on\n")
        fgather_selectivity_of_fix_r.write("\\x on\n")
        Q_WARMUP="select count(*) from {tbname} where image_embedding <<*>> '{{ 1,{image_embedding} }}';\n"
        for i in range(400):
            fbt_fix_r_exec.write(Q_WARMUP.format(tbname="Recipe_scalar",image_embedding=sample))
            fbt_fix_popularity_exec.write(Q_WARMUP.format(tbname="Recipe_scalar",image_embedding=sample))
            fhnsw_fix_r_exec.write(Q_WARMUP.format(tbname="Recipe",image_embedding=sample))
            fhnsw_fix_popularity_exec.write(Q_WARMUP.format(tbname="Recipe",image_embedding=sample))
        # enable timing
        TIMING_OPT="\\timing\n"
        fbt_fix_r_exec.write(TIMING_OPT)
        fbt_fix_popularity_exec.write(TIMING_OPT)
        fhnsw_fix_r_exec.write(TIMING_OPT)
        fhnsw_fix_popularity_exec.write(TIMING_OPT)
    for r in rlist_plan:
        fhnsw_fix_popularity_esti.write("explain select count(*) from Recipe where image_embedding <<*>> '{image_embedding}' and popularity < {p};\n".format(
            image_embedding='{'+str(r)+','+sample+'}',p=FIX_P
        ))
        fhnsw_fix_popularity_exec.write("select count(*) from Recipe where image_embedding <<*>> '{image_embedding}' and popularity < {p};\n".format(
            image_embedding='{'+str(r)+','+sample+'}',p=FIX_P
        ))
        fbt_fix_popularity_esti.write("explain select count(*) from Recipe_scalar where image_embedding <<*>> '{image_embedding}' and popularity < {p};\n".format(
            image_embedding='{'+str(r)+','+sample+'}',p=FIX_P
        ))
        fbt_fix_popularity_exec.write("select count(*) from Recipe_scalar where image_embedding <<*>> '{image_embedding}' and popularity < {p};\n".format(
            image_embedding='{'+str(r)+','+sample+'}',p=FIX_P
        ))
        fgather_selectivity_of_r.write("select count(*) from Recipe where image_embedding <<*>> '{image_embedding}';\n".format(
            image_embedding='{'+str(r)+','+sample+'}'
        ))
    for p in plist_plan:
        fbt_fix_r_esti.write("explain select count(*) from Recipe_scalar where image_embedding <<*>> '{image_embedding}' and popularity < {p};\n".format(
            image_embedding='{'+str(FIX_R)+','+sample+'}',p=p
        ))
        fbt_fix_r_exec.write("select count(*) from Recipe_scalar where image_embedding <<*>> '{image_embedding}' and popularity < {p};\n".format(
            image_embedding='{'+str(FIX_R)+','+sample+'}',p=p
        ))
        fhnsw_fix_r_esti.write("explain select count(*) from Recipe where image_embedding <<*>> '{image_embedding}' and popularity < {p};\n".format(
            image_embedding='{'+str(FIX_R)+','+sample+'}',p=p
        ))
        fhnsw_fix_r_exec.write("select count(*) from Recipe where image_embedding <<*>> '{image_embedding}' and popularity < {p};\n".format(
            image_embedding='{'+str(FIX_R)+','+sample+'}',p=p
        ))
    fgather_selectivity_of_fix_r.write("select count(*) from Recipe where image_embedding <<*>> '{image_embedding}';\n".format(
        image_embedding='{'+str(FIX_R)+','+sample+'}'
    ))
fbt_fix_r_esti.close()
fbt_fix_r_exec.close()
fbt_fix_popularity_esti.close()
fbt_fix_popularity_exec.close()
fhnsw_fix_popularity_esti.close()
fhnsw_fix_popularity_exec.close()
fhnsw_fix_r_esti.close()
fhnsw_fix_r_exec.close()
fgather_selectivity_of_r.close()
fgather_selectivity_of_fix_r.close()