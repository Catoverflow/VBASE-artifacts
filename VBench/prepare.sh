
DIRPATH=$(dirname "$0")
PATH_ES=`cd $DIRPATH && pwd`
PATH_VBENCH="${DIRPATH}/../raw_data"
PATH_VBENCH=`cd $PATH_VBENCH && pwd`
# Milvus
cd ${PATH_ES}/Milvus
mkdir volumes
## Deploy & Save data
bash deploy.sh
bash save_data.sh "${PATH_VBENCH}/collections"

## Build docker for search
cd milvus-sdk-cpp
sudo docker build -t milvus-sdk-cpp .


# ElasticSearch
cd ${PATH_ES}/ElasticSearch

## Deploy & Save data
bash es-deploy-opendistro.sh
sleep 60
bash save_data.sh "${PATH_VBENCH}/collections"
