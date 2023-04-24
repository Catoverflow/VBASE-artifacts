#!/bin/bash
DIRPATH=$(dirname "$0")
PATH_VectorDB="${DIRPATH}/../multi_column"
echo "Table-8 Query Running, it will take about 40 minutes."
echo "Run Queries in Table-8 by VBase"
${PATH_VectorDB}/run.sh
echo "Save and Analaysis Results..."
echo "Table-8"
echo "--------------------------------------------------"
${PATH_VectorDB}/eval.sh
echo "--------------------------------------------------"
