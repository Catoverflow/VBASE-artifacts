

def gen_gt():
    with open("./query.sql", "r") as f, \
        open("./query_gt.sql", "w") as out:
        f.readline()    #\c test_db;
        f.readline()    #\n
        out.write("set enable_indexscan=false;\n")
        out.write("\\c test_db;\n")
        out.write("\n")
        for i in range(10000):
            f.readline()    #\timing on
            sql = f.readline()
            f.readline()    #\timing off
            f.readline()    #\n
            sql_list = sql.split("\'")
            text_embedding = sql_list[9]
            image_embedding = sql_list[11]
            out.write("\\timing on\n")
            out.write(f"select id, (({text_embedding}) + ({image_embedding})) as score from d_table order by score limit 50;\n")
            out.write("\\timing off\n")
            out.write("\n")
        out.write("set enable_indexscan=true;\n")


def gen_query():
    with open("./query_ori.sql", "r") as f, \
        open("./query_1_10.sql", "w") as out:
        f.readline()    #\c test_db;
        f.readline()    #\n
        out.write("\\c test_db;\n")
        out.write("\n")
        for i in range(10000):
            f.readline()    #\timing on
            sql = f.readline()
            f.readline()    #\timing off
            f.readline()    #\n
            sql_list = sql.split("\'")
            text_embedding = sql_list[9]
            image_embedding = sql_list[11]
            rank_exp = f"({text_embedding}) + 10*({image_embedding})"
            out.write("\\timing on\n")
            out.write(f"select id from topk(\'d_table\', 50, 64, 100, \'id\', \'\', \'{rank_exp}\', \'{text_embedding}\', \'{image_embedding}\') as (id int, distance float);\n")
            out.write("\\timing off\n")
            out.write("\n")



if __name__ == "__main__":
    gen_query()