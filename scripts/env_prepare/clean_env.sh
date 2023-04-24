#!/bin/bash
DIRPATH=$(dirname "$0")
(cd $DIRPATH/../../VBench && bash clearindex.sh && sudo rm -rf Milvus/volumes)
