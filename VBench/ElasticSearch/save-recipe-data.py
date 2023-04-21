import csv
import json
import sys
import argparse
import requests

requests.packages.urllib3.disable_warnings(requests.packages.urllib3.exceptions.InsecureRequestWarning)


def str2bool(v):
    if isinstance(v, bool):
        return v
    if v.lower() in ('yes', 'true', 't', 'y', '1'):
        return True
    if v.lower() in ('no', 'false', 'f', 'n', '0'):
        return False
    raise argparse.ArgumentTypeError('Boolean value expected.')


def create_aknn_index(index_name):
    url = f"https://localhost:9200/{index_name}"
    headers = {
        'Content-Type': 'application/json'
    }
    payload = {
        "settings": {
            "index": {
                "knn": "true",
                "knn.space_type": "cosinesimil",
                "knn.algo_param.ef_search": 512,
                "knn.algo_param.ef_construction": 512
                # "knn.algo_param.m": 16
            }
        },
        "mappings": {
            "properties": {
                "embeds_image": {
                    "type": "knn_vector",
                    "dimension": 1024
                }
            }
        }
    }
    response = requests.request("PUT", url, headers=headers, data=json.dumps(payload), verify=False, auth=('admin', 'admin'))
    if not response.ok:
        print(response.status_code)
        print(response.text)
        sys.exit(1)
    # assert response.ok


def add_data_to_aknn_index(index_name, itemid, mode, embeds_image, price):
    headers = {
        'Content-Type': 'application/json'
    }
    key = "embeds_image"

    if mode == 'create':
        url = f"https://localhost:9200/{index_name}/_doc/{itemid}"
        payload = {
            "itemid": itemid,
            "embeds_image": embeds_image,
            # "text": text,
            "price": price
        }
        response = requests.request("PUT", url, headers=headers, data=json.dumps(payload), verify=False, auth=('admin', 'admin'))

        if not response.ok:
            print(response.status_code)
            print(response.text)
            sys.exit(1)
    elif mode == 'update':
        url = f"https://localhost:9200/{index_name}/_update/{itemid}"
        payload = {
            "doc": {
                key: embeds_image,
                # "text": text,
                "price": price
            }
        }
        response = requests.request("POST", url, headers=headers, data=json.dumps(payload), verify=False, auth=('admin', 'admin'))
        if not response.ok:
            print(response.status_code)
            print(response.text)
            sys.exit(1)


def save_recipe_data(path_image, path_text, path_number, index_name, start_line, mode, documents_to_save=-1, print_frequency=100):
    with open(path_image, 'r', encoding="utf8") as f_image, \
            open(path_text, 'r', encoding="utf8") as f_text, \
            open(path_number, 'r', encoding="utf8") as f_number:
        tsv_image = csv.reader(f_image, delimiter="\t")
        tsv_text = csv.reader(f_text, delimiter="\t")
        tsv_number = csv.reader(f_number, delimiter="\t")
        idx = 0
        for (cid, embeds_image), (_, price) in zip(tsv_image, tsv_number):
            if idx < start_line:
                idx += 1
                continue
            embeds_image = [float(ele) for ele in embeds_image[1:-1].split(', ')]
            # text = ingredient.replace('_', ' ') + " " + instruction.replace('_', ' ')
            # text = ingredient + instruction
            add_data_to_aknn_index(index_name, cid, mode, embeds_image, price)

            idx += 1
            if idx % print_frequency == 0:
                print(f"{idx} document embeddings saved...")
            if documents_to_save != -1 and idx >= documents_to_save:
                break
        print(f"{idx} document embeddings saved.")


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument('--create-index', type=str2bool, default=True,
                        help='whether to create index')
    parser.add_argument('--index-name', type=str, default="recipe",
                        help='index name')
    parser.add_argument('--path-embeds-image', type=str, default="../Recipe1M/data/vbench/collections/img_embeds_collection.tsv",
                        help='path to image embedding result')
    parser.add_argument('--path-text', type=str, default="../Recipe1M/data/vbench/collections/text_collection.tsv",
                        help='path to text')
    parser.add_argument('--path-number', type=str, default="../Recipe1M/data/vbench/collections/numbers.tsv",
                        help='path to number')
    parser.add_argument('--start-line', type=int, default=0,
                        help='start line')
    parser.add_argument('--mode', type=str, default="create",
                        help='create, update. Create the document or update the documents')
    parser.add_argument('--items-to-save', type=int, default=-1,
                        help='number of items to save')

    args = parser.parse_args()

    if args.create_index:
        create_aknn_index(args.index_name)
    save_recipe_data(args.path_embeds_image, args.path_text,
                     args.path_number, args.index_name, args.start_line, args.mode, args.items_to_save)
