import csv
import argparse

def query_generate(path_img, path_or, count):
    outputfile="/artifacts/scripts/postgres/query_run/table5_sample/sql/query_2_gt.sql"
    step = 10000/count
    with open(path_img, 'r', encoding="utf8") as f_img, \
         open(path_or, 'r', encoding="utf8") as f_or, \
         open(outputfile,'w',encoding="utf8") as out:
        tsv_img = csv.reader(f_img, delimiter="\t")
        tsv_or = csv.reader(f_or, delimiter="\t")
        idx = 0
        out.write("\\c postgres_db;\n\n")
        for (id, image_embedding), (_, popularity_count) in zip(tsv_img, tsv_or):
            if idx % step == 0:
                image_embedding=image_embedding[1:-1]
                
                out.write("\\timing on\n")
                out.write(f"select id from recipe_table where (popularity<={popularity_count}) order by image_embedding<*>ARRAY[{image_embedding}] limit 50;\n")
                out.write("\\timing off\n")
            idx += 1
            if idx==10000:
                break

if  __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument('--path-img', type=str, default="/artifacts/raw_data/queries/img_embeds.tsv", help='path to image embedding query')
    parser.add_argument('--path-or', type=str, default="/artifacts/raw_data/queries/price.tsv", help='path to query or filter')
    parser.add_argument('--count', type=int, default=100, help='query number')
    
    args = parser.parse_args()

    query_generate(args.path_img, args.path_or, args.count)
