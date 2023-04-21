DIRPATH=$(dirname "$0")
PATH_DIR="${DIRPATH}"
PATH_RESULT="${DIRPATH}/../result/Milvus"
PATH_VBENCH="${DIRPATH}/../../raw_data/"
echo "------------Milvus Result--------------"
echo "*Query 1"
ef=64
python3 ${PATH_DIR}/calculate-recall.py \
--path-search-results ${PATH_RESULT}/q1/qrels-${ef}.tsv \
--path-exact-results ${PATH_VBENCH}/exact/q1.tsv

python3 ${PATH_DIR}/calculate-latency.py \
--path-latency-result ${PATH_RESULT}/q1/latency-${ef}.tsv

echo "*Query 2"
ef=4096
python3 ${PATH_DIR}/calculate-recall.py \
--path-search-results ${PATH_RESULT}/q2/qrels-${ef}.tsv \
--path-exact-results ${PATH_VBENCH}/exact/q4.tsv

python3 ${PATH_DIR}/calculate-latency.py \
--path-latency-result ${PATH_RESULT}/q2/latency-${ef}.tsv

echo "*Query 4"
search_limit=2048
python3 ${PATH_DIR}/calculate-recall.py \
--path-search-results ${PATH_RESULT}/q4/qrels-${search_limit}.tsv \
--path-exact-results ${PATH_VBENCH}/exact/q2.tsv

python3 ${PATH_DIR}/calculate-latency.py \
--path-latency-result ${PATH_RESULT}/q4/latency-${search_limit}.tsv

echo "*Query 5"
search_limit=4096
python3 ${PATH_DIR}/calculate-recall.py \
--path-search-results ${PATH_RESULT}/q5/qrels-${search_limit}.tsv \
--path-exact-results ${PATH_VBENCH}/exact/q5.tsv

python3 ${PATH_DIR}/calculate-latency.py \
--path-latency-result ${PATH_RESULT}/q5/latency-${search_limit}.tsv
