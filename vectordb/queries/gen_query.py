import argparse

def gen_gt(weight, input_path):
    if weight == 1:
        output_path = "/artifacts/vectordb/queries/query_gt.sql"
    else:
        output_path = "/artifacts/vectordb/queries/query_gt_1_" + str(weight) + ".sql"
    with open(input_path, "r") as f, \
        open(output_path, "w") as out:
        f.readline()    #\c test_db;
        f.readline()    #\n
        f.readline()    #set
        f.readline()    #set
        out.write("set enable_indexscan=false;\n")
        out.write("\\c test_db;\n")
        out.write("\n")
        for _ in range(10000):
            f.readline()    #\timing on
            sql = f.readline()
            f.readline()    #\timing off
            f.readline()    #\n
            sql_list = sql.split("\'")
            text_embedding = sql_list[9]
            image_embedding = sql_list[11]
            out.write("\\timing on\n")
            if weight == 1:
                out.write(f"select id, (({text_embedding}) + ({image_embedding})) as score from d_table order by score limit 50;\n")
            else:
                out.write(f"select id, (({text_embedding}) + {weight} * ({image_embedding})) as score from d_table order by score limit 50;\n")
            out.write("\\timing off\n")
            out.write("\n")
        out.write("set enable_indexscan=true;\n")


def gen_query(weight, input_path):
    if weight == 1:
        output_path = "/artifacts/vectordb/queries/query.sql"
    else:
        output_path = "/artifacts/vectordb/queries/query_1_" + str(weight) + ".sql"
    with open(input_path, "r") as f, \
        open(output_path, "w") as out:
        f.readline()    #\c test_db;
        f.readline()    #\n
        f.readline()    #set
        f.readline()    #set
        out.write("\\c test_db;\n")
        out.write("\n")
        for _ in range(10000):
            f.readline()    #\timing on
            sql = f.readline()
            f.readline()    #\timing off
            f.readline()    #\n
            sql_list = sql.split("\'")
            text_embedding = sql_list[9]
            image_embedding = sql_list[11]
            if weight == 1:
                rank_exp = f"({text_embedding}) + ({image_embedding})"
            else:
                rank_exp = f"({text_embedding}) + {weight} * ({image_embedding})"
            out.write("\\timing on\n")
            out.write(f"select id from topk(\'d_table\', 50, 64, 100, \'id\', \'\', \'{rank_exp}\', \'{text_embedding}\', \'{image_embedding}\') as (id int, distance float);\n")
            out.write("\\timing off\n")
            out.write("\n")



if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument('--ori-query', type=str, default='/artifacts/scripts/vbase/query_run/table5/sql/query_4_vbase.sql',
                        help='original query path (Q4 in table5)')
    args = parser.parse_args()
    
    print("gen 1:1 ...")
    gen_query(1, args.ori_query)
    gen_gt(1, args.ori_query)
    print("gen 1:2 ...")
    gen_query(2, args.ori_query)
    gen_gt(2, args.ori_query)
    print("gen 1:5 ...")
    gen_query(5, args.ori_query)
    gen_gt(5, args.ori_query)
    print("gen 1:10 ...")
    gen_query(10, args.ori_query)
    gen_gt(10, args.ori_query)
