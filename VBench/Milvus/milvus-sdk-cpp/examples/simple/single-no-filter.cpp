#include <algorithm>
#include <fstream>
#include <iostream>
#include <map>
#include <random>
#include <set>
#include <string>

#include "milvus/MilvusClient.h"
#include "milvus/types/CollectionSchema.h"

int topk = 50;
int nprobe = 8192;
int search_limit = 2048;
const int SIZE_COLLECTION = 330922;
const int SIZE_QUERY = 10000;
const std::string img_collection_name = "recipe_img_normalized";
const std::string ins_collection_name = "recipe_instr_normalized";
std::string outputResult = "/result/";
int m = 1024;

std::map<float, float> RESULT;

void
CheckStatus(std::string&& prefix, const milvus::Status& status) {
    if (!status.IsOk()) {
        std::cout << prefix << " " << status.Message() << std::endl;
        exit(1);
    }
}

struct HIT {
    float id;
    float score;
    HIT(float ID, float SCORE) : id(ID), score(SCORE) {
    }
};

bool
NRA(std::vector<std::vector<HIT> > HitData, std::map<float, float>& RESULT, int topk, float minScore) {
    bool flag = false;
    std::unordered_map<float, float> UB, LB;
    std::vector<std::unordered_map<float, float> > matrix;
    std::vector<float> lastExistValue;
    std::unordered_set<float> seenIDSet;
    matrix.resize(HitData.size());
    lastExistValue.resize(HitData.size());
    int max_len = HitData[0].size();
    for (auto id : HitData) max_len = std::max(max_len, (int)id.size());
    for (int i = 0; i < max_len; i++) {
        for (int j = 0; j < HitData.size(); j++)
            if (HitData[j].size() > i) {
                matrix[j][HitData[j][i].id] = HitData[j][i].score;
                seenIDSet.insert(HitData[j][i].id);
                lastExistValue[j] = HitData[j][i].score;
            }

        for (auto id : seenIDSet) {
            LB[id] = 0;
            UB[id] = 0;
            for (int k = 0; k < HitData.size(); k++)
                if (matrix[k].find(id) == matrix[k].end()) {
                    LB[id] += minScore;
                    UB[id] += lastExistValue[k];
                } else {
                    LB[id] += matrix[k][id];
                    UB[id] += matrix[k][id];
                }
        }
        if (LB.size() > topk) {
            std::vector<float> LB_value;
            for (auto x : LB) LB_value.push_back(x.second);
            int Rank = LB_value.size() - topk;
            std::nth_element(LB_value.begin(), LB_value.begin() + Rank, LB_value.end());
            float LB_topk = LB_value[Rank], UB_max = -100;

            for (auto x : LB) {
                float id = x.first, lbValue = x.second;
                if (lbValue <= LB_topk)
                    UB_max = std::max(UB_max, UB[id]);
            }

            if (LB_topk >= UB_max) {
                flag = true;
                break;
            }
        }
    }
    RESULT.clear();
    int validnumber = 0;
    for (auto x : LB) {
        float id = x.first, lb_value = x.second;
        RESULT[-lb_value] = x.first;
        while (RESULT.size() > topk) {
            auto tmp = RESULT.end();
            tmp--;
            RESULT.erase(tmp);
        }
    }
    return flag;
}

int
main(int argc, char* argv[]) {
    std::string img_filename = "/embeddings/img_embeds_query.tsv";

    std::cout << "input topk = ";
    std::cin >> topk;
    std::cout << "input nprobe = ";
    std::cin >> nprobe;

    printf("Experiments start...\n");

    auto client = milvus::MilvusClient::Create();

    milvus::ConnectParam connect_param{"localhost", 19530};
    auto status = client->Connect(connect_param);
    CheckStatus("Failed to connect milvus server:", status);
    std::cout << "Connect to milvus server." << std::endl;

    status = client->LoadCollection(img_collection_name);
    CheckStatus("Failed to load collection:", status);
    std::cout << "Load collection succesfully." << std::endl;

    milvus::CollectionStat coll_stat;
    status = client->GetCollectionStatistics(img_collection_name, coll_stat);
    CheckStatus("Failed to get collection statistics:", status);
    std::cout << "Collection " << img_collection_name << " row count: " << coll_stat.RowCount() << std::endl;
    
    std::ifstream img_in(img_filename);

    std::vector<float> img_query_id;
    std::vector<std::vector<float> > img_query;
    img_query.resize(SIZE_QUERY);
    std::string line;
    int num = 0;
    for (; getline(img_in, line);) {
        img_query_id.push_back(std::stof(line.substr(0, line.find("\t"))));

        line.erase(0, line.find("[") + 1);
        for (int j = 0; j < m - 1; j++) {
            img_query[num].push_back(std::stof(line.substr(0, line.find(","))));
            line.erase(0, line.find(",") + 2);
        }
        img_query[num].push_back(std::stof(line.substr(0, line.find("]"))));
        // normalization;
        double sum = 0.0;
        for (auto i = 0; i < img_query[num].size(); i++) sum += img_query[num][i] * img_query[num][i];
        sum = sqrt(sum);
        for (auto i = 0; i < img_query[num].size(); i++) img_query[num][i] /= sum;
        num++;
    }
    std::cout << num << " img queries has been read." << std::endl;

    std::string output_result_path = outputResult + std::to_string(nprobe) +"qrels-filter.txt";
    std::string output_lantency_path = outputResult + std::to_string(nprobe) + "latency-filter.txt";
    std::ofstream out1(output_result_path);
    std::ofstream out2(output_lantency_path);

    for (int i = 0; i < SIZE_QUERY; i++) {
        double Begin_time = clock();
        std::cout << "search start." << std::endl;
        
        bool flag = false;
        int TOPK = topk;

        milvus::SearchArguments img_arguments{};
        img_arguments.SetCollectionName(img_collection_name);
        img_arguments.SetTopK(TOPK);
        img_arguments.AddTargetVector("img_embeds", img_query[i]);
        img_arguments.AddExtraParam("nprobe", nprobe);
        img_arguments.SetMetricType(milvus::MetricType::IP);
        milvus::SearchResults img_search_results{};
        auto status = client->Search(img_arguments, img_search_results); 
        CheckStatus("Failed to search:", status);

        for (auto& img_result : img_search_results.Results()) {
            auto& img_ids = img_result.Ids().IntIDArray();
            auto& img_distances = img_result.Scores();
            if (img_ids.size() != img_distances.size()) {
                std::cout << "img Illegal result!" << std::endl;
                continue;
            }
            double End_time = clock();
            int len = img_ids.size();
            std::cout << "img Successfully search, " << len << "results." << std::endl;

            out2 << img_query_id[i] << " " << (End_time - Begin_time) / CLOCKS_PER_SEC << std::endl;
            int rank = 0;
            for (int j = 0; j < len; j++)
                out1 << img_query_id[i] << " " << img_ids[j] << " " << ++rank << " " << img_distances[j] << std::endl;
            for (int j = len; j < topk; j++)
                out1 << img_query_id[i] << " " << -1 << " " << ++rank << " " << -1 << std::endl;
        }

        int number = i + 1;
        if (number % 5 == 0)
            std::cout << number << " queries searched." << std::endl;
    }
    return 0;
}
