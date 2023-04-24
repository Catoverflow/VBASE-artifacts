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
const int SIZE_COLLECTION = 330922;
const int SIZE_QUERY = 10000;
const std::string img_collection_name = "recipe_img_normalized";
const std::string ins_collection_name = "recipe_instr_normalized";
std::string outputResult = "/result/";
int m = 1024;

std::string img_filename = "/embeddings/img_embeds.tsv";
std::string ins_filename = "/embeddings/rec_embeds.tsv";
std::string filter_filename = "/embeddings/price.tsv";

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

void
q1(int ef) {
    printf("Search starting...\n");

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

    std::string output_result_path = outputResult + "q1/qrels-" + std::to_string(ef) + ".tsv";
    std::string output_lantency_path = outputResult + "q1/latency-" + std::to_string(ef) + ".tsv";
    std::ofstream out1(output_result_path);
    std::ofstream out2(output_lantency_path);

    for (int i = 0; i < SIZE_QUERY; i++) {
        auto startTime = std::chrono::high_resolution_clock::now();
        
        bool flag = false;
        int TOPK = topk;

        milvus::SearchArguments img_arguments{};
        img_arguments.SetCollectionName(img_collection_name);
        img_arguments.SetTopK(TOPK);
        img_arguments.AddTargetVector("img_embeds", img_query[i]);
        img_arguments.AddExtraParam("ef", ef);
        img_arguments.SetMetricType(milvus::MetricType::IP);
        milvus::SearchResults img_search_results{};
        auto status = client->Search(img_arguments, img_search_results); 
        CheckStatus("Failed to search:", status);

        for (auto& img_result : img_search_results.Results()) {
            auto& img_ids = img_result.Ids().IntIDArray();
            auto& img_distances = img_result.Scores();
            if (img_ids.size() != img_distances.size()) {
                std::cout << "img illegal result!" << std::endl;
                continue;
            }

            auto endTime = std::chrono::high_resolution_clock::now();
            out2 << img_query_id[i] << "\t" << std::chrono::duration_cast<std::chrono::microseconds>(endTime - startTime).count() / 1000000.0 << std::endl;

            int len = img_ids.size();
            int rank = 0;
            for (int j = 0; j < len; j++)
                out1 << img_query_id[i] << "\t" << img_ids[j] << "\t " << ++rank << "\t" << img_distances[j] << std::endl;
            for (int j = len; j < topk; j++)
                out1 << img_query_id[i] << "\t" << -1 << "\t" << ++rank << "\t" << -1 << std::endl;
        }

        int number = i + 1;
        if (number % 1000 == 0)
            std::cout << number <<  " queries searched." << std::endl;
    }
}

void
q2(int ef){
    printf("Search starting...\n");

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
    std::ifstream filter_in(filter_filename);

    std::vector<float> img_query_id;
    std::vector<int> prices;
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
    
    num = 0;
    for (; getline(filter_in, line);) {
        line.erase(0, line.find("\t") + 1);
        // ingre_num.push_back(std::stoi(line.substr(0, line.find("\t"))));
        // line.erase(0, line.find("\t") + 1);
        prices.push_back(std::stoi(line.substr(0, line.find("\n"))));
        num++;
    }
    std::cout << num << " filter has been read." << std::endl;
    std::string output_result_path = outputResult + "q2/qrels-" + std::to_string(ef) + ".tsv";
    std::string output_lantency_path = outputResult + "q2/latency-" + std::to_string(ef) + ".tsv";
    std::ofstream out1(output_result_path);
    std::ofstream out2(output_lantency_path);

    for (int i = 0; i < SIZE_QUERY; i++) {
        auto startTime = std::chrono::high_resolution_clock::now();
        
        bool flag = false;
        int TOPK = topk;

        milvus::SearchArguments img_arguments{};
        img_arguments.SetCollectionName(img_collection_name);
        img_arguments.SetTopK(TOPK);
        img_arguments.AddTargetVector("img_embeds", img_query[i]);
        img_arguments.AddExtraParam("ef", ef);
        // img_arguments.SetExpression("ingredient_count <= " + std::to_string(ingre_num[i]) + " || instruction_step <= " + std::to_string(instruct_step[i]));
        img_arguments.SetExpression("price <= " + std::to_string(prices[i]));
        img_arguments.SetMetricType(milvus::MetricType::IP);
        milvus::SearchResults img_search_results{};
        auto status = client->Search(img_arguments, img_search_results); 
        CheckStatus("Failed to search:", status);

        for (auto& img_result : img_search_results.Results()) {
            auto& img_ids = img_result.Ids().IntIDArray();
            auto& img_distances = img_result.Scores();
            if (img_ids.size() != img_distances.size()) {
                std::cout << "img illegal result!" << std::endl;
                continue;
            }
            int len = img_ids.size();

            int rank = 0;
            for (int j = 0; j < len; j++)
                out1 << img_query_id[i] << "\t" << img_ids[j] << "\t" << ++rank << "\t" << img_distances[j] << std::endl;
            for (int j = len; j < topk; j++)
                out1 << img_query_id[i] << "\t" << -1 << "\t" << ++rank << "\t" << -1 << std::endl;
        }

        auto endTime = std::chrono::high_resolution_clock::now();
        out2 << img_query_id[i] << "\t" << std::chrono::duration_cast<std::chrono::microseconds>(endTime - startTime).count() / 1000000.0 << std::endl;

        int number = i + 1;
        if (number % 1000 == 0)
            std::cout << number <<  " queries searched." << std::endl;
    }
}

void 
q4(int search_limit, int step=1){
    printf("Search starting...\n");

    auto client = milvus::MilvusClient::Create();
    milvus::ConnectParam connect_param{"localhost", 19530};
    auto status = client->Connect(connect_param);
    CheckStatus("Failed to connect milvus server:", status);
    std::cout << "Connect to milvus server." << std::endl;

    status = client->LoadCollection(img_collection_name);
    CheckStatus("Failed to load collection:", status);
    status = client->LoadCollection(ins_collection_name);
    CheckStatus("Failed to load collection:", status);
    std::cout << "Load collection succesfully." << std::endl;

    milvus::CollectionStat coll_stat;
    status = client->GetCollectionStatistics(img_collection_name, coll_stat);
    CheckStatus("Failed to get collection statistics:", status);
    std::cout << "Collection " << img_collection_name << " row count: " << coll_stat.RowCount() << std::endl;
    status = client->GetCollectionStatistics(ins_collection_name, coll_stat);
    CheckStatus("Failed to get collection statistics:", status);
    std::cout << "Collection " << ins_collection_name << " row count: " << coll_stat.RowCount() << std::endl;

    std::ifstream img_in(img_filename);
    std::ifstream ins_in(ins_filename);

    std::vector<float> img_query_id, ins_query_id;
    std::vector<std::vector<float> > img_query, ins_query;
    img_query.resize(SIZE_QUERY);
    ins_query.resize(SIZE_QUERY);
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
    num = 0;
    for (; getline(ins_in, line);) {
        ins_query_id.push_back(std::stof(line.substr(0, line.find("\t"))));

        line.erase(0, line.find("[") + 1);
        for (int j = 0; j < m - 1; j++) {
            ins_query[num].push_back(std::stof(line.substr(0, line.find(","))));
            line.erase(0, line.find(",") + 2);
        }
        ins_query[num].push_back(std::stof(line.substr(0, line.find("]"))));
        // normalization;
        double sum = 0.0;
        for (auto i = 0; i < ins_query[num].size(); i++) sum += ins_query[num][i] * ins_query[num][i];
        sum = sqrt(sum);
        for (auto i = 0; i < ins_query[num].size(); i++) ins_query[num][i] /= sum;
        num++;
    }
    std::cout << num << " ins queries has been read." << std::endl;
    std::string output_result_path = outputResult + "q4/qrels-" + std::to_string(search_limit) + ".tsv";
    std::string output_lantency_path = outputResult + "q4/latency-" + std::to_string(search_limit) + ".tsv";
    
    std::ofstream out1(output_result_path);
    std::ofstream out2(output_lantency_path);

    for (int i = 0; i < SIZE_QUERY; i+=step) {
        auto startTime = std::chrono::high_resolution_clock::now();
        int kprime = 1;
        while (kprime < topk) kprime *= 2;
        while (kprime <= search_limit && kprime <= SIZE_COLLECTION) {
            bool flag = false;
            // int nprobe = std::ceil(((float)TOPK) / (((float)SIZE_COLLECTION) / ((float)nlist)));
            milvus::SearchArguments img_arguments{};
            img_arguments.SetCollectionName(img_collection_name);
            img_arguments.AddExtraParam("ef", kprime);
            img_arguments.SetMetricType(milvus::MetricType::IP);
            img_arguments.AddTargetVector("img_embeds", img_query[i]);
            img_arguments.SetTopK(kprime);

            milvus::SearchArguments ins_arguments{};
            ins_arguments.SetCollectionName(ins_collection_name);
            ins_arguments.AddExtraParam("ef", kprime);
            ins_arguments.SetMetricType(milvus::MetricType::IP);
            ins_arguments.AddTargetVector("rec_embeds", ins_query[i]);
            milvus::SearchResults img_search_results{};
            auto status = client->Search(img_arguments, img_search_results);
            CheckStatus("Failed to search:", status);

            ins_arguments.SetTopK(kprime);
            milvus::SearchResults ins_search_results{};
            status = client->Search(ins_arguments, ins_search_results);
            CheckStatus("Failed to search:", status);

            for (auto& img_result : img_search_results.Results()) {
                auto& img_ids = img_result.Ids().IntIDArray();
                auto& img_distances = img_result.Scores();
                if (img_ids.size() != img_distances.size()) {
                    std::cout << "img illegal result!" << std::endl;
                    continue;
                }
                // std::cout << "img successfully searched " << img_ids.size() << " results." << std::endl;
                for (auto& ins_result : ins_search_results.Results()) {
                    auto& ins_ids = ins_result.Ids().IntIDArray();
                    auto& ins_distances = ins_result.Scores();
                    if (ins_ids.size() != ins_distances.size()) {
                        std::cout << "img illegal result!" << std::endl;
                        continue;
                    }
                    // std::cout << "ins successfully searched" << ins_ids.size() << " results." << std::endl;

                    std::vector<std::vector<HIT> > HitData;
                    HitData.resize(2);
                    for (int i = 0; i < img_ids.size(); i++)
                        HitData[0].push_back(HIT(img_ids[i], img_distances[i]));
                    for (int i = 0; i < ins_ids.size(); i++)
                        HitData[1].push_back(HIT(ins_ids[i], ins_distances[i]));

                    flag = NRA(HitData, RESULT, topk, -1);
                    // std::cout << "NRA finish, has " << RESULT.size() << "results." << std::endl;
                }
            }

            if (flag)
                break;
            kprime *= 2;
        }
        int rank = 0;
        for (auto x : RESULT) {
            out1 << img_query_id[i] << "\t" << x.second << "\t" << ++rank << "\t" << -x.first << std::endl;
            if (rank == 50)
                break;
        }
        for (int ii = 0; ii < 50 - RESULT.size(); ii++)
            out1 << img_query_id[i] << "\t" << -1 << "\t" << ++rank << "\t" << -1 << std::endl;

        auto endTime = std::chrono::high_resolution_clock::now();
        out2 << img_query_id[i] << "\t" << std::chrono::duration_cast<std::chrono::microseconds>(endTime - startTime).count() / 1000000.0 << std::endl;
        
        int number = i + 1;
        if (number % 50 == 0)
            std::cout << number / step <<  " queries searched." << std::endl;
    }
}

void 
q5(int search_limit, int step=1){
    printf("Search starting...\n");

    auto client = milvus::MilvusClient::Create();
    milvus::ConnectParam connect_param{"localhost", 19530};
    auto status = client->Connect(connect_param);
    CheckStatus("Failed to connect milvus server:", status);
    std::cout << "Connect to milvus server." << std::endl;

    status = client->LoadCollection(img_collection_name);
    CheckStatus("Failed to load collection:", status);
    status = client->LoadCollection(ins_collection_name);
    CheckStatus("Failed to load collection:", status);
    std::cout << "Load collection succesfully." << std::endl;

    milvus::CollectionStat coll_stat;
    status = client->GetCollectionStatistics(img_collection_name, coll_stat);
    CheckStatus("Failed to get collection statistics:", status);
    std::cout << "Collection " << img_collection_name << " row count: " << coll_stat.RowCount() << std::endl;
    status = client->GetCollectionStatistics(ins_collection_name, coll_stat);
    CheckStatus("Failed to get collection statistics:", status);
    std::cout << "Collection " << ins_collection_name << " row count: " << coll_stat.RowCount() << std::endl;

    std::ifstream img_in(img_filename);
    std::ifstream ins_in(ins_filename);
    std::ifstream filter_in(filter_filename);

    std::vector<float> img_query_id, ins_query_id;
    std::vector<int> prices;
    std::vector<std::vector<float> > img_query, ins_query;
    img_query.resize(SIZE_QUERY);
    ins_query.resize(SIZE_QUERY);
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
    num = 0;
    for (; getline(ins_in, line);) {
        ins_query_id.push_back(std::stof(line.substr(0, line.find("\t"))));

        line.erase(0, line.find("[") + 1);
        for (int j = 0; j < m - 1; j++) {
            ins_query[num].push_back(std::stof(line.substr(0, line.find(","))));
            line.erase(0, line.find(",") + 2);
        }
        ins_query[num].push_back(std::stof(line.substr(0, line.find("]"))));
        // normalization;
        double sum = 0.0;
        for (auto i = 0; i < ins_query[num].size(); i++) sum += ins_query[num][i] * ins_query[num][i];
        sum = sqrt(sum);
        for (auto i = 0; i < ins_query[num].size(); i++) ins_query[num][i] /= sum;
        num++;
    }
    std::cout << num << " ins queries has been read." << std::endl;
    num = 0;
    for (; getline(filter_in, line);) {
        line.erase(0, line.find("\t") + 1);
        prices.push_back(std::stoi(line.substr(0, line.find("\n"))));
        num++;
    }
    std::cout << num << " filter has been read." << std::endl;
    std::string output_result_path = outputResult + "q5/qrels-" + std::to_string(search_limit) + ".tsv";
    std::string output_lantency_path = outputResult + "q5/latency-" + std::to_string(search_limit) + ".tsv";
    std::ofstream out1(output_result_path);
    std::ofstream out2(output_lantency_path);

    for (int i = 0; i < SIZE_QUERY; i+=step) {
        auto startTime = std::chrono::high_resolution_clock::now();
        int kprime = 1;
        while (kprime < topk) kprime *= 2;
        while (kprime <= search_limit && kprime <= SIZE_COLLECTION) {
            bool flag = false;
            int TOPK = kprime;
            // int nprobe = std::ceil(((float)TOPK) / (((float)SIZE_COLLECTION) / ((float)nlist)));
            milvus::SearchArguments img_arguments{};
            img_arguments.SetCollectionName(img_collection_name);
            img_arguments.SetTopK(TOPK);
            img_arguments.AddTargetVector("img_embeds", img_query[i]);
            img_arguments.AddExtraParam("ef", kprime);
            img_arguments.SetExpression("price <= " + std::to_string(prices[i]));
            img_arguments.SetMetricType(milvus::MetricType::IP);
            milvus::SearchResults img_search_results{};
            auto status = client->Search(img_arguments, img_search_results); 
            CheckStatus("Failed to search:", status);

            milvus::SearchArguments ins_arguments{};
            ins_arguments.SetCollectionName(ins_collection_name);
            ins_arguments.SetTopK(TOPK);
            ins_arguments.AddTargetVector("rec_embeds", ins_query[i]);
            ins_arguments.AddExtraParam("ef", kprime);
            ins_arguments.SetExpression("price <= " + std::to_string(prices[i]));
            ins_arguments.SetMetricType(milvus::MetricType::IP);
            milvus::SearchResults ins_search_results{};
            status = client->Search(ins_arguments, ins_search_results);
            CheckStatus("Failed to search:", status);

            for (auto& img_result : img_search_results.Results()) {
                auto& img_ids = img_result.Ids().IntIDArray();
                auto& img_distances = img_result.Scores();
                if (img_ids.size() != img_distances.size()) {
                    std::cout << "img illegal result!" << std::endl;
                    continue;
                }
                // std::cout << "img successfully search, " << img_ids.size() << "results." << std::endl;
                for (auto& ins_result : ins_search_results.Results()) {
                    auto& ins_ids = ins_result.Ids().IntIDArray();
                    auto& ins_distances = ins_result.Scores();
                    if (ins_ids.size() != ins_distances.size()) {
                        std::cout << "img illegal result!" << std::endl;
                        continue;
                    }

                    std::vector<std::vector<HIT> > HitData;
                    HitData.resize(2);
                    for (int i = 0; i < img_ids.size(); i++)
                        HitData[0].push_back(HIT(img_ids[i], img_distances[i]));
                    for (int i = 0; i < ins_ids.size(); i++)
                        HitData[1].push_back(HIT(ins_ids[i], ins_distances[i]));

                    flag = NRA(HitData, RESULT, topk, -1);
                    // std::cout << "NRA finish, has " << RESULT.size() << "results." << std::endl;
                }
            }
            if (flag)
                break;
            kprime *= 2;
        }
        auto endTime = std::chrono::high_resolution_clock::now();
        out2 << img_query_id[i] << "\t" << std::chrono::duration_cast<std::chrono::microseconds>(endTime - startTime).count() / 1000000.0 << std::endl;
        
        int rank = 0;
        for (auto x : RESULT) {
            out1 << img_query_id[i] << "\t" << x.second << "\t" << ++rank << "\t" << -x.first << std::endl;
            if (rank == 50)
                break;
        }
        for (int ii = 0; ii < 50 - RESULT.size(); ii++)
            out1 << img_query_id[i] << "\t" << -1 << "\t" << ++rank << "\t" << -1 << std::endl;
        
        int number = i + 1;
        if (number % 50 == 0)
            std::cout << number / step <<  " queries searched." << std::endl;
    }
}

int
main(int argc, char* argv[]) {
    q1(64);
    q2(4096);

    int step = std::atoi(argv[1]);
    q4(2048, step);
    q5(4096, step);

    return 0;
}
