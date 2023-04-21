#!/bin/bash
DIRPATH=$(dirname "$0")
PATH_DIR="${DIRPATH}"
echo `date "+DATE: %Y-%m-%d %H:%M:%S"`
echo "++++++++++++++++++++++++++++++++++++++++"
${PATH_DIR}/run_table_5.sh
echo `date "+DATE: %Y-%m-%d %H:%M:%S"`
echo ""
echo "++++++++++++++++++++++++++++++++++++++++"
${PATH_DIR}/run_table_6.sh
echo `date "+DATE: %Y-%m-%d %H:%M:%S"`
echo ""
echo "++++++++++++++++++++++++++++++++++++++++"
${PATH_DIR}/run_table_7.sh
echo `date "+DATE: %Y-%m-%d %H:%M:%S"`
echo ""
echo "++++++++++++++++++++++++++++++++++++++++"
${PATH_DIR}/run_table_8.sh
echo `date "+DATE: %Y-%m-%d %H:%M:%S"`
echo ""
echo "++++++++++++++++++++++++++++++++++++++++"
