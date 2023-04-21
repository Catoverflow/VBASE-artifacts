
PATH_VBENCH="/datadrive/vbench"
PATH_RESULT="/datadrive/gusui/VBench/result"
echo "Path of collections, queries & ground-truth: ${PATH_VBENCH}"

sudo mkdir -p "${PATH_RESULT}/Milvus/q1" "${PATH_RESULT}/Milvus/q2" "${PATH_RESULT}/Milvus/q4" "${PATH_RESULT}/Milvus/q5"
sudo mkdir -p "${PATH_RESULT}/ElasticSearch/q1" "${PATH_RESULT}/ElasticSearch/q2" "${PATH_RESULT}/ElasticSearch/q3"

# Milvus, Search
echo "********************************************"
echo "Searching with Milvus (Q1, Q2, Q4, Q5)..."
echo "********************************************"
cd Milvus
sudo docker run -itd \
    --name=milvus-sdk-cpp \
    -v ${PATH_VBENCH}/queries:/embeddings \
    -v ${PATH_RESULT}/Milvus:/result \
    --net=host \
    milvus-sdk-cpp:latest
sudo docker exec -it milvus-sdk-cpp /milvus-sdk-cpp/build/examples/simple/sdk_simple 100 # step = 100

# ES, Search & Eval
echo "********************************************"
echo "Searching with ElasticSearch (Q1, Q2, Q3)..."
echo "********************************************"
cd ../ElasticSearch
sudo bash search.sh

# Evaluation
cd ..
echo "********************************************"
echo "Evaluation of Milvus:"
echo "********************************************"
bash eval/milvus.sh

echo "********************************************"
echo "Evaluation of ElasticSearch:"
echo "********************************************"
bash eval/elasticsearch.sh
