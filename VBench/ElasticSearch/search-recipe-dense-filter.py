import csv
import gzip
import json
import argparse
import requests

requests.packages.urllib3.disable_warnings(requests.packages.urllib3.exceptions.InsecureRequestWarning)


def search_query_dense_number(knn_key, query_embedding, k, price):
    """return a tuple(docid, rank, score, latency)
    """
    url = "https://localhost:9200/recipe/_search"
    headers = {
        'Content-Type': 'application/json'
    }
    payload = {
        "size": 50,
        "query": {
            "knn": {
                knn_key: {
                    "vector": query_embedding,
                    "k": k
                }
            }
        },
        "post_filter": {
            "bool": {
                "should": [
                    {"range": {"price": {"lte": [price]}}},
                ]
            }
        }
    }
    response = requests.request("GET", url, headers=headers, data=json.dumps(payload), verify=False, auth=('admin', 'admin'))
    res = json.loads(response.text)
    latency = response.elapsed.total_seconds()
    return [(record["_source"]["itemid"], idx+1, record["_score"]) for idx, record in enumerate(res["hits"]["hits"])], latency


def search_query_dense_string(knn_key, query_embedding, k, ingredient):
    """return a tuple(docid, rank, score, latency)
    """
    url = "https://localhost:9200/recipe/_search"
    headers = {
        'Content-Type': 'application/json'
    }
    payload = {
        "size": 50,
        "query": {
            "knn": {
                knn_key: {
                    "vector": query_embedding,
                    "k": k
                }
            }
        },
        "post_filter": {
            "bool": {
                "must_not": {
                    "match": {"text": ingredient.replace('_', ' ')}
                }
            }
        }
    }
    response = requests.request("GET", url, headers=headers, data=json.dumps(payload), verify=False, auth=('admin', 'admin'))
    res = json.loads(response.text)
    latency = response.elapsed.total_seconds()
    return [(record["_source"]["itemid"], idx+1, record["_score"]) for idx, record in enumerate(res["hits"]["hits"])], latency


def search_queries(filter_type, path_query_filter, inverted_index_key, path_query_embeds, knn_key, path_qrels, path_latency, k, queries=-1, print_frequency=100):
    with open(path_query_filter, 'rt', encoding="utf8") as f_query_filter, \
            open(path_query_embeds, 'rt', encoding="utf8") as f_query_embeds, \
            open(path_qrels, 'w', encoding="utf8") as out, \
            open(path_latency, 'w', encoding="utf8") as out_latency:
        tsvreader_query_add = csv.reader(f_query_filter, delimiter="\t")
        tsvreader_query_embedding = csv.reader(f_query_embeds, delimiter="\t")
        idx = 0
        for [qid, query_embedding], [_, filter1] in zip(tsvreader_query_embedding, tsvreader_query_add):
            query_embedding = [float(ele) for ele in query_embedding[1:-1].split(', ')]
            if filter_type == 'string':
                result, latency = search_query_dense_string(knn_key, query_embedding, k, filter1)
            elif filter_type == 'number':
                result, latency = search_query_dense_number(knn_key, query_embedding, k, int(filter1))
            # save search result in TREC format `qid 0 pid rank score IndriQueryLikelihood & format `qid latency`.
            num = 0
            for (id, rank, score) in result:
                out.write(f"{qid}\t{id}\t{rank}\t{score}\n")
                num = rank
            rank = num
            for i in range(num, 50):
                rank = rank + 1
                out.write(f"{qid}\t{-1}\t{rank}\t{-1}\n")
            out_latency.write(f"{qid}\t{latency}\n")
            idx += 1
            if idx % print_frequency == 0:
                out.flush()
                out_latency.flush()
                print(f"{idx} queries searched...")
            if queries != -1 and idx >= queries:
                break
        print(f"{idx} queries searched.")


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument('--filter-type', type=str, default='no',
                        help='no, numeric, string')
    parser.add_argument('--path-query-embeds', type=str,
                        default='../Recipe1M/embedding/split/img_embeds_query.tsv',
                        help='path to query embedding result')
    parser.add_argument('--path-query-filter', type=str,
                        default='../Recipe1M/embedding/split/ingredients_text_query.tsv',
                        help='path to query embedding result')
    parser.add_argument('--inverted-index-key', type=str, default='text',
                        help='text')
    parser.add_argument('--knn-key', type=str, default='embeds_image',
                        help='embeds_image')
    parser.add_argument('--k', type=int, default=100,
                        help='the number of knn to return')
    parser.add_argument('--path-search-result', type=str, default="../result/VBench/es-dense-sparse-result.tsv",
                        help='path to save search result')
    parser.add_argument('--path-latency-result', type=str, default="../result/VBench/es-dense-sparse-latency.tsv",
                        help='path to save latency result')
    parser.add_argument('--queries-to-search', type=int, default=-1,
                        help='number of queries to search')
    parser.add_argument('--log-frequency', type=int, default=100,
                        help='log frequency')

    args = parser.parse_args()

    search_queries(
        args.filter_type,
        args.path_query_filter, args.inverted_index_key,
        args.path_query_embeds, args.knn_key,
        args.path_search_result, args.path_latency_result,
        args.k, args.queries_to_search, args.log_frequency)
