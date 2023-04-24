DIRPATH=$(dirname "$0")
PATH_RESULT="${DIRPATH}/../result/"
docker rm milvus-sdk-cpp -f
rm -rf $PATH_RESULT/*
