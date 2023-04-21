#!/bin/bash

# start ES and run in background
sudo sysctl -w vm.max_map_count=262144
sudo docker pull amazon/opendistro-for-elasticsearch:1.13.3

sudo docker run --name es01 \
        -p 9200:9200 \
        -p 9600:9600 \
        -e "discovery.type=single-node" \
        -v "$(pwd)"/config/jvm.options:/usr/share/elasticsearch/config/jvm.options.d/jvm.options \
        -d amazon/opendistro-for-elasticsearch:1.13.3
