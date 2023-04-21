import csv
import argparse
import os

def save_recipe_data(path_data, path_result):
    with open(path_data, 'r', encoding="utf8") as f_data, \
         open(path_result,'w',encoding="utf8") as out:
        csv.field_size_limit(500*1024*1024)
        tsv_data = csv.reader(f_data, delimiter="\t")
        idx = 0
        for (id, json_str) in tsv_data:
            json_list = json_str.split(',')
            simple_json=''
            i = 0
            for json_item in json_list:
                i= i + 1
                simple_json = simple_json + json_item
                if i == 10:
                    break
                simple_json = simple_json + ','
            if len(json_list) == 10:
                simple_json=simple_json
            else:
                if i < 10 and i > 0:
                    simple_json=simple_json[:-1]
                elif i > 0:
                    simple_json = simple_json + '}'

            out.write(f"{id}\t{simple_json}\n")
            idx += 1
            if idx%10000 == 0:
                print(f"{idx} rows data saved...")

if  __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument('--path-data', type=str, default="../raw_data/collections/img_embeds_collection.tsv",
                        help='path to image embedding data')
    parser.add_argument('--path-result', type=str, default="../raw_data/collections/img_embeds_collection.tsv",
                        help='path t result')
    args = parser.parse_args()
    
    if os.path.exists(args.path_result):
        print("file exists")
        exit()
    save_recipe_data(args.path_data, args.path_result)
