#!/bin/bash
sudo mkdir /dev/shm/artifacts
sudo chmod 777 /dev/shm/artifacts
sudo mkdir /dev/shm/multicol
sudo chmod 777 /dev/shm/multicol
DIRPATH=$(dirname "$0")
cd $DIRPATH/../../vectordb/ && ./tests/dockerbuild.sh && ./tests/dockerrun.sh && ./tests/dockerrun_multicolumn.sh
