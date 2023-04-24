#!/bin/bash

PATH_EMBEDDING=$1

echo "Saving data to ES..."
sudo apt install python3-pip -y
python3 -m pip install -r requirements.txt

# save collections to ES
python3 save-recipe-data.py \
--index-name "recipe" \
--path-embeds-image "$PATH_EMBEDDING/img_embeds_collection.tsv" \
--path-text "$PATH_EMBEDDING/text.tsv" \
--path-number "$PATH_EMBEDDING/price.tsv" \
--start-line 0 --mode "create" \
--create-index true