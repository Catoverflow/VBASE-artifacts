# Milvus Cpp SDK

Cpp SDK for [Milvus](https://github.com/milvus-io/milvus). To contribute to this project, please read our [contribution guidelines](https://github.com/milvus-io/milvus/blob/master/CONTRIBUTING.md) first.


## Run Examples with Docker

```
sudo docker build -t milvus-sdk-cpp .

sudo docker run -itd \
    --name=milvus-sdk-cpp \
    --net=host \
    milvus-sdk-cpp:latest

sudo docker exec -it milvus-sdk-cpp /milvus-sdk-cpp/build/examples/simple/sdk_simple
```