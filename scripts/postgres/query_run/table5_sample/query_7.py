import csv
import argparse

def query_generate(path_img, count):
    outputfile="/artifacts/scripts/postgres/query_run/table5_sample/sql/query_7_gt.sql"
    step = int(10000 / count);
    with open(path_img, 'r', encoding="utf8") as f_img, \
         open(outputfile,'w',encoding="utf8") as out:
        tsv_img= csv.reader(f_img, delimiter="\t")
        idx = 0
        out.write("\\c pase_db;\n\n")
        out.write("set enable_seqscan=on;\n")
        out.write("set enable_indexscan=off;\n")
        for (id, image_embedding) in tsv_img:
            if idx % step == 0:
                image_embedding=image_embedding[1:-1]
                out.write("\\timing on\n")
                out.write(f"select id from recipe_table where image_embedding<<*>>ARRAY[0.1, {image_embedding}];\n")
                out.write("\\timing off\n\n")
            
            idx += 1
            if idx==10000:
                break

if  __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument('--path-img', type=str, default="/artifacts/raw_data/queries/img_embeds.tsv", help='path to image embedding query')
    parser.add_argument('--count', type=int, default=100, help='query number')
    args = parser.parse_args()

    query_generate(args.path_img, args.count)
