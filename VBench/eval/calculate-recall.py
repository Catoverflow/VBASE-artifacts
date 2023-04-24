import argparse
import pandas as pd

if  __name__ == "__main__":
    parser = argparse.ArgumentParser()
    # parser.add_argument('--k', type=int, default=50,
    #                     help='top k')
    parser.add_argument('--path-search-results', type=str, default="../result/Recipe1M/test-qrels-top50-nprobe16-limit4096.tsv",
                        help='path to embedding result')
    parser.add_argument('--path-exact-results', type=str, default="../result/Recipe1M/test-qrels-exact-top50.tsv",
                        help='path to embedding result')
    args = parser.parse_args()

    df_qrels = pd.read_csv(args.path_search_results, header=None, delimiter='\t')
    df_qrels.columns = ['qid', 'rid', 'rank', 'score']
    df_qrels = df_qrels.drop(columns=['rank', 'score'])

    df_exact = pd.read_csv(args.path_exact_results, header=None, delimiter='\t')  
    df_exact.columns = ['qid', 'rid', 'rank', 'score']
    df_exact = df_exact.drop(columns=['rank', 'score'])

    df_int = pd.merge(df_qrels, df_exact, how='inner', on=['qid', 'rid'])

    # print(df_int.shape[0])
    # print(df_exact.shape[0])

    # print(df_qrels[:50])
    # print(df_exact[:50])
    # print(df_int[:50])

    # print(f"recall of {df_qrels.shape[0]} qrels: {df_int.shape[0]/df_qrels.shape[0]:.4f}")
    print(f"Recall: {df_int.shape[0]/df_qrels.shape[0]:.4f}")
    # print(f"recall of {df_qrels.shape[0]} qrels: {df_int.shape[0]/df_exact.shape[0]:.4f}")
