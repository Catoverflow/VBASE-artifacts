DIRPATH=$(dirname "$0")
PATH_DIR="${DIRPATH}"
PATH_RESULT="${DIRPATH}/../result/ElasticSearch"
PATH_VBENCH="${DIRPATH}/../../raw_data/"
echo "------------ElasticSearch Result--------------"
echo "Query 1"
k=256
python3 ${PATH_DIR}/calculate-recall.py \
--path-search-results ${PATH_RESULT}/q1/qrels-${k}.tsv \
--path-exact-results ${PATH_VBENCH}/exact/q1.tsv

python3 ${PATH_DIR}/calculate-latency.py \
--path-latency-result ${PATH_RESULT}/q1/latency-${k}.tsv

echo "Query 2"
python3 ${PATH_DIR}/calculate-recall.py \
--path-search-results ${PATH_RESULT}/q2/qrels-${k}.tsv \
--path-exact-results ${PATH_VBENCH}/exact/q4.tsv

python3 ${PATH_DIR}/calculate-latency.py \
--path-latency-result ${PATH_RESULT}/q2/latency-${k}.tsv

echo "Query 3"
python3 ${PATH_DIR}/calculate-recall.py \
--path-search-results ${PATH_RESULT}/q3/qrels-${k}.tsv \
--path-exact-results ${PATH_VBENCH}/exact/q7.tsv

python3 ${PATH_DIR}/calculate-latency.py \
--path-latency-result ${PATH_RESULT}/q3/latency-${k}.tsv
