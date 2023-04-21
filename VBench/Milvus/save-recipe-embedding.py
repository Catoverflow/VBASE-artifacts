import argparse
import os
import csv
import numpy as np
from pymilvus import (
    connections,
    utility,
    FieldSchema,
    CollectionSchema,
    DataType,
    Collection,
)

parser = argparse.ArgumentParser()
parser.add_argument('--img-collection-name', type=str, default="recipe_img_normalized",
                    help='image collection name')
parser.add_argument('--instr-collection-name', type=str, default="recipe_instr_normalized",
                    help='instruction collection name')
parser.add_argument('--path-embedding', type=str, default="../Recipe1M/data/vbench/collections",
                    help='path to embedding result')
parser.add_argument('--start-line', type=int, default=0,
                    help='start line')
parser.add_argument('--normalization', type=int, default=1,
                    help='vector normalization, 0 or 1')
parser.add_argument('--number-to-save', type=int, default=-1,
                help='number of embeddings to save')
args = parser.parse_args()

# Connect to Milvus
connections.connect(
	alias="default",
	host='127.0.0.1',
	port='19530'
	)
if utility.has_collection(args.img_collection_name):
    utility.drop_collection(args.img_collection_name)
if utility.has_collection(args.instr_collection_name):
    utility.drop_collection(args.instr_collection_name)
# string type not supported: https://github.com/milvus-io/milvus/issues/4430
# multiple vector fields is not supported
schema = CollectionSchema(
    fields=[
        FieldSchema(name="pk", dtype=DataType.INT64, is_primary=True, auto_id=False),
        FieldSchema(name="img_embeds", dtype=DataType.FLOAT_VECTOR, dim=1024),
        FieldSchema(name="price", dtype=DataType.INT64)
    ],
    description="Recipe1M Images"
    )
img_collection = Collection(args.img_collection_name, schema)
schema = CollectionSchema(
    fields=[
        FieldSchema(name="pk", dtype=DataType.INT64, is_primary=True, auto_id=False),
        FieldSchema(name="rec_embeds", dtype=DataType.FLOAT_VECTOR, dim=1024),
        FieldSchema(name="price", dtype=DataType.INT64)
    ],
    description="Recipe1M Instructions"
    )
instr_collection = Collection(args.instr_collection_name, schema)

def save_embeddings(path_embedding, path_data, collection, start_line, normalization, number_to_save=-1, print_frequency=100):
    with open(path_embedding, 'r', encoding="utf8") as f:
        with open(path_data, 'r', encoding="utf8") as f_data:
            tsvreader = csv.reader(f, delimiter="\t")
            tsv_data = csv.reader(f_data, delimiter="\t")
            idx = 0
            count = 0
            for (rid, vec), (_, price) in zip(tsvreader, tsv_data):
                idx += 1
                if idx < start_line:
                    continue
                vec = [float(ele) for ele in vec[1:-1].split(', ')]
                if normalization:
                    vec = (vec / np.linalg.norm(vec)).tolist()
                # print(int(number_ingredients), int(instru_step),idx)
                collection.insert([[int(rid)], [vec], [int(price)]])
                idx += 1
                count += 1
                if count % print_frequency == 0:
                    print(f"{count} embeddings saved...")
                if number_to_save != -1 and count >= number_to_save:
                    break
            print(f"{count} embeddings saved.")

def create_index():
    print("Creating indexes...")
    img_collection.create_index("img_embeds", {
        "index_type": "HNSW",
        "metric_type": "IP",
        "params": {"M": 16, "efConstruction": 200}
    })
    instr_collection.create_index("rec_embeds", {
        "index_type": "HNSW",
        "metric_type": "IP",
        "params": {"M": 16, "efConstruction": 200}
    })
    print("Indexes Created.")

if  __name__ == "__main__":
    print("Saving image embeddings...")
    save_embeddings(
        os.path.join(args.path_embedding,'img_embeds_collection.tsv'),
        os.path.join(args.path_embedding,'price.tsv'),
        img_collection,
        args.start_line,
        args.normalization,
        args.number_to_save,
        print_frequency=100)
    print("Image embeddings saved.")

    print("Saving instr embeddings...")
    save_embeddings(
        os.path.join(args.path_embedding,'rec_embeds_collection.tsv'),
        os.path.join(args.path_embedding,'price.tsv'),
        instr_collection,
        args.start_line,
        args.normalization,
        args.number_to_save,
        print_frequency=100)
    print("Instr embeddings saved.")

    print("Creating index...")
    create_index()
    print("Index created.")