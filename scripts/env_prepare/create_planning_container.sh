DOCKER_IMAGE=vbase_artifacts
DIRPATH=$(dirname "$0")
PATH_DIR="${DIRPATH}/../planning"
PATH_PLAN=`cd $PATH_DIR && pwd`
echo "Running container 1/2 for planning test"
mkdir /dev/shm/planning && chmod 777 /dev/shm/planning && docker run --name=vbase_planning_exec\
     -e PGPASSWORD=vectordb -e PGUSERNAME=vectordb -e PGDATABASE=vectordb \
     -v /dev/shm/planning:/u02 -v $PATH_PLAN:/planning $DOCKER_IMAGE &
echo "Running container 2/2 for planning test"
docker run --name=vbase_planning_esti -e PGPASSWORD=vectordb -e PGUSERNAME=vectordb -e PGDATABASE=vectordb \
     -v $PATH_PLAN:/planning $DOCKER_IMAGE &
sleep 10 && docker cp $PATH_PLAN/vectordb vbase_planning_esti:/tmp && \
docker exec -u 0 vbase_planning_esti bash -c \
     "cd /tmp/vectordb && rm -rf build && mkdir -p build && cd build && cmake .. && make -j && make install"
