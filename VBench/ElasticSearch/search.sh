DIRPATH=$(dirname "$0")
PATH_ES="${DIRPATH}"
PATH_RESULT="${DIRPATH}/../result/ElasticSearch"
PATH_VBENCH="${DIRPATH}/../../raw_data/"
mkdir -p "${PATH_RESULT}/q1" "${PATH_RESULT}/q2" "${PATH_RESULT}/q3"
# Q1: Single-Vector TopK
#PATH_VBENCH=`cd $PATH_VBENCH && pwd`
#PATH_RESULT=`cd $PATH_RESULT && pwd`
#echo $PATH_VBENCH
#echo $PATH_REULST
#echo `pwd`
k=256
python3 ${PATH_ES}/search-recipe-dense.py \
--path-query-embeds "${PATH_VBENCH}/queries/img_embeds.tsv" \
--knn-key "embeds_image" \
--k ${k} \
--path-search-result "${PATH_RESULT}/q1/qrels-${k}.tsv" \
--path-latency-result "${PATH_RESULT}/q1/latency-${k}.tsv" \
--log-frequency 1000

# Q2:Single-Vector TopK+Numeric Filter
python3 ${PATH_ES}/search-recipe-dense-filter.py \
--filter-type "number" \
--path-query-filter "${PATH_VBENCH}/queries/price.tsv" \
--path-query-embeds "${PATH_VBENCH}/queries/img_embeds.tsv" \
--inverted-index-key "text" \
--knn-key "embeds_image" \
--k ${k} \
--path-search-result "${PATH_RESULT}/q2/qrels-${k}.tsv" \
--path-latency-result "${PATH_RESULT}/q2/latency-${k}.tsv" \
--log-frequency 1000

# Q3:Single-Vector TopK+String Filter
python3 ${PATH_ES}/search-recipe-dense-filter.py \
--filter-type "string" \
--path-query-filter "${PATH_VBENCH}/queries/string_filter.tsv" \
--path-query-embeds "${PATH_VBENCH}/queries/img_embeds.tsv" \
--inverted-index-key "text" \
--knn-key "embeds_image" \
--k ${k} \
--path-search-result "${PATH_RESULT}/q3/qrels-${k}.tsv" \
--path-latency-result "${PATH_RESULT}/q3/latency-${k}.tsv" \
--log-frequency 1000
