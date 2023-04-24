#!/bin/bash
DIRPATH=$(dirname "$0")
PATH_DIR="${DIRPATH}"
#(cd $PATH_DIR &&./run_planning.sh)
(cd $PATH_DIR/../result_analysis && python3 planning.py)
