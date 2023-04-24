import csv
import argparse

def query_generate(path_img):
    outputfile="/artifacts/scripts/postgres/query_run/table5/sql/query_1_gt.sql"
    
    with open(path_img, 'r', encoding="utf8") as f_data, \
         open(outputfile,'w',encoding="utf8") as out:
        tsv_data= csv.reader(f_data, delimiter="\t")
        idx = 0
        out.write("\\c pase_db;\n\n")
        out.write("set enable_seqscan=on;\n")
        out.write("set enable_indexscan=off;\n")
        
        for (id, image_embedding) in tsv_data:
            image_embedding=image_embedding[1:-1]
            out.write("\\timing on\n")
            out.write(f"select id from recipe_table order by image_embedding <*> ARRAY[{image_embedding}] limit 50;\n")
            out.write("\\timing off\n\n")
            
            idx += 1
            if idx%1000 == 0:
                print(f"{idx} document embeddings saved...")
            #if idx==100:
            #    break

if  __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument('--path-img', type=str, default="/artifacts/raw_data/queries/img_embeds.tsv", help='path to image embedding query')

    args = parser.parse_args()

    query_generate(args.path_img)
