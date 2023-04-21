## Deploy Milvus client

```bash
./deploy.sh
```

## Save collections

```bash
echo "Saving embedding results to Milvus..."
python3 -m pip install -r requirements.txt

# save collections to Milvus
python3 save-recipe-embedding.py \
--img-collection-name "recipe_img_normalized" \
--instr-collection-name "recipe_instr_normalized" \
--normalization 1 \
--path-embedding "/datadrive/data/VBASE/data/vbench/collections" \
--path-embedding "/datadrive/data/VBASE/data/vbench/collections" \
--start-line 0
```

## Milvus CLI
```bash
pip3 install milvus-cli==0.1.8
milvus_cli

connect -h localhost -p 19530 -a default
# connect -h 127.0.0.1 -p 19530 -a default
describe collection -c recipe_img_normalized
describe collection -c recipe_img_normalized
load -c recipe_img
load -c recipe_instr

create index (recipe_img_normalized, recipe_instr_normalized, HNSW, IP, 16, 40)
delete index -c recipe_img_normalized
delete index -c recipe_instr_normalized
exit
```

## Search with Mivlus C++ SDK
```bash
cd Milvus
git clone --branch benchmark git@ssh.dev.azure.com:v3/gusui/VBASE/milvus-sdk-cpp

# build image
cd milvus-sdk-cpp
sudo docker build -t milvus-sdk-cpp .

# run container
cd VBench
sudo docker run -itd \
    --name=milvus-sdk-cpp \
    -v /datadrive/data/VBASE/data/vbench/queries:/embeddings \
    -v $PWD/result/Milvus/q2:/result \
    --net=host \
    milvus-sdk-cpp:latest

# run tests inside container
sudo docker exec -it milvus-sdk-cpp ls /embeddings
sudo docker exec -it milvus-sdk-cpp ls /result
sudo docker exec -it milvus-sdk-cpp /milvus-sdk-cpp/build/examples/simple/sdk_simple

sudo docker rm milvus-sdk-cpp -f
```