import argparse

def dump_results(path):
    num_of_scans = []
    result_set = []
    time_set = []
    with open(path, "r") as f:
        f.readline()
        for i in range(10000):
            _ = f.readline()    # Timing is on.
            # not ground truth file
            if ("gt" not in path):
                line = f.readline() # num_of_scans
                num_of_scans.append(int(line.split(" ")[-1]))
            _ = f.readline()    # id | score
            _ = f.readline()    # ----+-----
            
            temp_result = []
            for j in range(50):
                line = f.readline()
                temp_result.append(int(line.split('|')[0]))
            result_set.append(temp_result)
            
            _ = f.readline() # (50 rows)
            _ = f.readline() # \n
            line = f.readline() # time: xxms
            time_set.append(float(line.split(" ")[1]))
            _ = f.readline() # Timing is off.
    return num_of_scans, result_set, time_set

def calcu_time(time_set):
    return sum(time_set[1:]) / len(time_set[1:])    #drop the first time

def calcu_num_of_scans(num_of_scans_set):
    return sum(num_of_scans_set) / len(num_of_scans_set)

def calcu_recall(result_set, gt_set):
    recall_set = []
    for i in range(10000):
        recall = len(set(result_set[i]) & set(gt_set[i])) / len(gt_set[i])
        recall_set.append(recall)
    return recall_set

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument('--gt', type=str, default='./groundtruth/gt.txt',
                        help='Ground Truth Path')
    parser.add_argument('--round-robin', type=str, default='./results/before.txt',
                        help='Round-Robin result')
    parser.add_argument('--vbase', type=str, default='./results/after.txt',
                        help='VBase result')
    parser.add_argument('--greedy', type=str, default='./results/greedy.txt',
                        help='Greedy result')
    args = parser.parse_args()

    _, result_gt, _ = dump_results(args.gt)
    num_of_scans_before, result_before, time_before = dump_results(args.round_robin)
    recall_set_before = calcu_recall(result_before, result_gt)

    num_of_scans_after, result_after, time_after = dump_results(args.vbase)
    recall_set_after = calcu_recall(result_after, result_gt)

    num_of_scans_greedy, result_greedy, time_greedy = dump_results(args.greedy)
    recall_set_greedy = calcu_recall(result_greedy, result_gt)
    
    
    print("[Round-Robin] NumberOfScans = %.2f, Latency = %.2fms, Recall = %.4f" \
            % (calcu_num_of_scans(num_of_scans_before), calcu_time(time_before), sum(recall_set_before)/10000))
    
    print("[Greedy]      NumberOfScans = %.2f, Latency = %.2fms, Recall = %.4f" \
            % (calcu_num_of_scans(num_of_scans_greedy), calcu_time(time_greedy), sum(recall_set_greedy)/10000))
    
    print("[VBase]       NumberOfScans = %.2f, Latency = %.2fms, Recall = %.4f" \
            % (calcu_num_of_scans(num_of_scans_after), calcu_time(time_after), sum(recall_set_after)/10000))