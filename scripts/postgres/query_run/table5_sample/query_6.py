import csv
import argparse

def query_generate(path_img, path_rec, path_string, count):
    outputfile="/artifacts/scripts/postgres/query_run/table5_sample/sql/query_6_gt.sql"
    step = int(10000 / count);
    with open(path_img, 'r', encoding="utf8") as f_img, \
         open(path_rec, 'r', encoding="utf8") as f_rec, \
         open(path_string, 'r', encoding="utf8") as f_string, \
         open(outputfile,'w',encoding="utf8") as out:
        tsv_img= csv.reader(f_img, delimiter="\t")
        tsv_rec= csv.reader(f_rec, delimiter="\t")
        tsv_string= csv.reader(f_string, delimiter="\t")
        idx = 0
        out.write("\\c pase_db;\n\n")
        out.write("set enable_seqscan=on;\n")
        out.write("set enable_indexscan=off;\n")
        for (id, image_embedding), (_, text_embedding), (_, word)  in zip(tsv_img, tsv_rec, tsv_string):
            if idx % step == 0:
                image_embedding = image_embedding[1:-1]
                text_embedding = text_embedding[1:-1]
                word = word.replace('\'','')
            
                out.write("\\timing on\n")
                out.write(f"select id from recipe_table where (description NOT LIKE '%{word}%') order by ((text_embedding <*> ARRAY[{text_embedding}])+(image_embedding <*> ARRAY[{image_embedding}])) limit 50;\n")
                out.write("\\timing off\n\n")
            
            idx += 1
            if idx==10000:
                break

if  __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument('--path-img', type=str, default="/artifacts/raw_data/queries/img_embeds.tsv", help='path to image embedding query')
    parser.add_argument('--path-rec', type=str, default="/artifacts/raw_data/queries/rec_embeds.tsv", help='path to text embedding query')
    parser.add_argument('--path-string', type=str, default="/artifacts/raw_data/queries/string_filter.tsv", help='path to query string filter')
    parser.add_argument('--count', type=int, default=100, help='query number')
    args = parser.parse_args()

    query_generate(args.path_img,args.path_rec,args.path_string,args.count)
