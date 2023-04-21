import csv
import argparse
import os

def save_recipe_data(path_data):
    with open(path_data, 'r', encoding="utf8") as f_data, \
         open("json.tsv",'w',encoding="utf8") as out:
        csv.field_size_limit(500*1024*1024)
        tsv_data = csv.reader(f_data, delimiter="\t")
        idx = 0
        for (id, _, _, _, _, _, json_str) in tsv_data:
            out.write(f"{id}\t{json_str}\n")
            idx += 1
            if idx%10000 == 0:
                print(f"{idx} rows data saved...")

if  __name__ == "__main__":
    if os.path.exists("json.tsv"):
        print("file exists")
        exit()
    parser = argparse.ArgumentParser()
    parser.add_argument('--path-data', type=str, default="../raw_data/collections/img_embeds_collection.tsv",
                        help='path to image embedding result')

    args = parser.parse_args()

    save_recipe_data(args.path_data)
