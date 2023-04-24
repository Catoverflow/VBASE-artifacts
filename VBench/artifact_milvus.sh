DIRPATH=$(dirname "$0")
PATH_ES="${DIRPATH}"
PATH_RESULT="${DIRPATH}/result"
PATH_VBENCH="${DIRPATH}/../raw_data"
PATH_RESULT=`cd $PATH_RESULT && pwd`
PATH_VBENCH=`cd $PATH_VBENCH && pwd`
mkdir -p "${PATH_RESULT}/Milvus/q1" "${PATH_RESULT}/Milvus/q2" "${PATH_RESULT}/Milvus/q4" "${PATH_RESULT}/Milvus/q5"

# Milvus, Search
echo "********************************************"
echo "Searching with Milvus (Q1, Q2, Q4, Q5)..."
echo "********************************************"
docker run -itd \
    --name=milvus-sdk-cpp \
    -v ${PATH_VBENCH}/queries:/embeddings \
    -v ${PATH_RESULT}/Milvus:/result \
    --net=host \
    milvus-sdk-cpp:latest
docker exec -it milvus-sdk-cpp /milvus-sdk-cpp/build/examples/simple/sdk_simple 100 # step = 100

