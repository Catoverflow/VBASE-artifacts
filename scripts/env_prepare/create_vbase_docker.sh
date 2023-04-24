#!/bin/bash
sudo mkdir /dev/shm/artifacts
sudo chmod 777 /dev/shm/artifacts
sudo mkdir /dev/shm/multicol
sudo chmod 777 /dev/shm/multicol
DIRPATH=$(dirname "$0")
pip install -r $DIRPATH/requirements.txt
(cd $DIRPATH/../../vectordb/ && ./tests/dockerbuild.sh && ./tests/dockerrun.sh && ./tests/dockerrun_multicolumn.sh)
(cd $DIRPATH && ./create_planning_container.sh)
