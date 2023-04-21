import argparse
import statistics
import pandas as pd

def calculate_latency(path):
    res_latency = pd.read_csv(path, delimiter='\t')
    latency = res_latency.iloc[:, 1].tolist()
    latency.sort()

    latency = [i * 1000 for i in latency] # to ms
    print(f"Latency average / median / 99th (ms): {statistics.mean(latency):.1f}, {statistics.median(latency):.1f}, {latency[int(0.99*len(latency))]:.1f}")

if  __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument('--path-latency-result', type=str, default='../result/Recipe1M/test-qrels-latency-top50-nprobe8-limit1024.tsv',
                        help='path to latency result')

    args = parser.parse_args()
    calculate_latency(args.path_latency_result)
