#!/bin/bash
/artifacts/scripts/data_prepare/data_download.sh
python3 /artifacts/scripts/data_prepare/simple_json.py --path-data /artifacts/raw_data/collections/json.tsv --path-result /artifacts/scripts/data_prepare/simple_json.tsv
python3 /artifacts/scripts/data_prepare/data_gen_with_json.py --path-image-embedding /artifacts/raw_data/collections/img_embeds_collection.tsv --path-text-embedding /artifacts/raw_data/collections/rec_embeds_collection.tsv --path-text-data /artifacts/raw_data/collections/text.tsv --path-number-data /artifacts/raw_data/collections/price.tsv --path-json /artifacts/scripts/data_prepare/simple_json.tsv --path-result /artifacts/scripts/data_prepare/data_source.tsv
python3 /artifacts/scripts/data_prepare/tag_data_gen.py --path-image-embedding /artifacts/raw_data/queries/img_embeds.tsv --path-result /artifacts/scripts/data_prepare/tag_datasource.tsv
