import csv
import argparse

def query_generate():
    outputfile="/artifacts/scripts/postgres/query_run/table5_sample/sql/query_8_gt.sql"

    with open(outputfile,'w',encoding="utf8") as out:
        #idx = 0
        out.write("\\c pase_db;\n\n")
        out.write("set enable_seqscan=on;\n")
        out.write("set enable_indexscan=off;\n")
        out.write("\\timing on\n")
        out.write(f"select recipe_table.id as did, tag_table.id as tid, d_table.image_embedding<*>t_table.image_embedding as distance   from recipe_table join tag_table   on recipe_table.image_embedding <<*>> array_cat(ARRAY[cast(0.01 as float8)], tag_table.image_embedding);\n")
        out.write("\\timing off\n\n")

if  __name__ == "__main__":
    parser = argparse.ArgumentParser()

    args = parser.parse_args()

    query_generate()
