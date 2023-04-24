#!/bin/bash
DIRPATH=$(dirname "$0")
PATH_DIR="${DIRPATH}"

(cd $PATH_DIR/../result_analysis && python3 q_error.py)
