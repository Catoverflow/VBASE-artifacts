import csv
import argparse

def query_generate(path_img):
    outputfile="/artifacts/scripts/pase/query_run/table7/sql/query_range_r_pase.sql"

    with open(path_img, 'r', encoding="utf8") as f_img, \
         open(outputfile,'w',encoding="utf8") as out:
        tsv_img= csv.reader(f_img, delimiter="\t")
        idx = 0
        out.write("\\c pase_db;\n\n")
        out.write("set enable_seqscan=off;\n")
        out.write("set enable_indexscan=on;\n")
        for (id, image_embedding) in tsv_img:
            image_embedding=image_embedding[1:-1]
            out.write("\\timing on\n")
            out.write(f"select id from recipe_table where (image_embedding<*>ARRAY[{image_embedding}])<=0.1 order by image_embedding<*>ARRAY[{image_embedding}] limit 10000;\n")
            out.write("\\timing off\n\n")
            
            idx += 1
            if idx%1000 == 0:
                print(f"{idx} document embeddings saved...")
            if idx==10000:
                break

if  __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument('--path-img', type=str, default="/artifacts/raw_data/queries/img_embeds.tsv", help='path to image embedding query')

    args = parser.parse_args()

    query_generate(args.path_img)
