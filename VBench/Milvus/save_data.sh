#!/bin/bash

# "/datadrive/data/VBASE/data/vbench/collections"
PATH_EMBEDDING=$1

echo "Saving data to Milvus..."
sudo apt install python3-pip -y
python3 -m pip install -r requirements.txt

# save collections to Milvus
python3 save-recipe-embedding.py \
--img-collection-name "recipe_img_normalized" \
--instr-collection-name "recipe_instr_normalized" \
--normalization 1 \
--path-embedding $PATH_EMBEDDING \
--start-line 0
