import csv
import gzip
import json
import argparse
import requests

requests.packages.urllib3.disable_warnings(requests.packages.urllib3.exceptions.InsecureRequestWarning)


def search_query_dense(knn_key, query_embeds, k):
    """return a tuple(docid, rank, score, latency)
    """
    url = "https://localhost:9200/recipe/_search"
    headers = {
        'Content-Type': 'application/json'
    }
    payload = {
        "size": 50,
        "query": {
            "bool": {
                "should": [
                    {
                        "script_score": {
                            "query": {
                                "knn": {
                                    knn_key: {
                                        "vector": query_embeds,
                                        "k": k
                                    }
                                }
                            },
                            "script": {
                                "source": "(3.0 - (1.0 / _score))"
                            }
                        }
                    }
                ],
                "minimum_should_match": 1
            }
        }
    }
    response = requests.request("GET", url, headers=headers, data=json.dumps(payload), verify=False, auth=('admin', 'admin'))
    res = json.loads(response.text)
    latency = response.elapsed.total_seconds()
    return [(record["_source"]["itemid"], idx+1, record["_score"]) for idx, record in enumerate(res["hits"]["hits"])], latency


def search_queries(query_embeds_path, knn_key, path_qrels, path_latency, k, queries=-1, print_frequency=100):
    with open(query_embeds_path, 'rt', encoding="utf8") as f_query_embeds, \
            open(path_qrels, 'w', encoding="utf8") as out, \
            open(path_latency, 'w', encoding="utf8") as out_latency:
        tsvreader_query_embeds = csv.reader(f_query_embeds, delimiter="\t")
        idx = 0
        for qid, query_embeds in tsvreader_query_embeds:
            query_embeds = [float(ele) for ele in query_embeds[1:-1].split(', ')]
            result, latency = search_query_dense(knn_key, query_embeds, k)
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
    parser.add_argument('--path-query-embeds', type=str,
                        default='../Recipe1M/embedding/split/img_embeds_query.tsv',
                        help='path to query embedding result')
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
        args.path_query_embeds, args.knn_key,
        args.path_search_result, args.path_latency_result,
        args.k, args.queries_to_search, args.log_frequency)
