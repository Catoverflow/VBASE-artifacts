DOCKER_IMAGE=vbase_artifacts
echo "Running container 1/2 for planning test"
mkdir /dev/shm/planning && chmod 777 /dev/shm/planning && docker run --name=vbase_planning_exec\
     -v /dev/shm/planning:/u02  -e PGPASSWORD=vectordb -e PGUSERNAME=vectordb -e PGDATABASE=vectordb \
     -p 15432:5432 $DOCKER_IMAGE &
echo "Running container 2/2 for planning test"
docker run --name=vbase_planning_esti -e PGPASSWORD=vectordb -e PGUSERNAME=vectordb -e PGDATABASE=vectordb \
     -p 25432:5432 $DOCKER_IMAGE &
sleep 10 && docker cp ../vectordb vbase_planning_esti:/tmp && \
docker exec -u 0 vbase_planning_esti bash -c \
     "cd /tmp/vectordb && mkdir -p build && cd build && cmake .. && make -j && make install"