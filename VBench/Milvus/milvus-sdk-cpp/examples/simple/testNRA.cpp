#include <algorithm>
#include <iostream>
#include <map>
#include <random>
#include <set>
#include <string>
#include <unordered_map>
#include <unordered_set>

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
main() {
    std::map<float, float> RESULT;
    std::vector<HIT> col_0 = {HIT(1, 1), HIT(2, 0.8), HIT(3, 0.5), HIT(4, 0.3), HIT(5, 0.1)};
    std::vector<HIT> col_1 = {HIT(2, 0.8), HIT(3, 0.7), HIT(1, 0.3), HIT(4, 0.2), HIT(5, 0.1)};
    std::vector<HIT> col_2 = {HIT(4, 0.8), HIT(3, 0.6), HIT(1, 0.2), HIT(5, 0.1), HIT(2, 0.0), HIT(9, -1.0)};
    std::vector<std::vector<HIT> > HitData = {col_0, col_1, col_2};

    bool flag = NRA(HitData, RESULT, 2, -1);
    std::cout << "flag: " << flag << std::endl;

    int rank = 0;
    for (auto x : RESULT) {
        std::cout << " " << x.second << " " << ++rank << " " << -x.first << std::endl;
    }

    flag = NRA(HitData, RESULT, 10, -1);
    std::cout << "flag: " << flag << std::endl;

    rank = 0;
    for (auto x : RESULT) {
        std::cout << " " << x.second << " " << ++rank << " " << -x.first << std::endl;
    }
}
